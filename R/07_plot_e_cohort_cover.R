# Purpose: partition Coki E measured area by original-object cohort ancestry.
# Run from the report after workflows 03 and 06. Inputs are the configured
# Matches rows and the current object-lineage audit, held in memory.
# Outputs: per-object area assignment, cohort cover, species area and checks in
# outputs/Tables/. Objects are counted once, regardless of original ancestors.
# Unassigned ancestry is preserved. Cross-cohort fusion area is kept mixed,
# never allocated to both cohorts or split using an assumed proportion.

# Settings ----
plot_e_cover_cohort_order <- c("2025 original outplants", "April 2026 additions",
                              "Unassigned", "Mixed cohorts")
plot_e_cover_palette <- c("2025 original outplants" = "#0072B2",
                         "April 2026 additions" = "#D55E00",
                         "Unassigned" = "#777777", "Mixed cohorts" = "#8A6FDF")

# File paths ----
plot_e_cover_output_dir <- file.path(outplant_project_root, "outputs", "Tables")

# 1. Build one measured record per section, survey and current object ----
plot_e_cover_rows <- outplant_interval_rows |>
  filter(plot == "Plot E") |>
  mutate(blob_start = as.character(blob_start), blob_end = as.character(blob_end))
plot_e_cover_snapshots <- bind_rows(
  plot_e_cover_rows |>
    filter(month_start_date == plot_e_original_date, present_start) |>
    transmute(plot_section, survey_date = month_start_date, object_id = blob_start,
              area_m2 = area_start_m2, species, plot_area_m2),
  plot_e_cover_rows |>
    filter(present_end) |>
    transmute(plot_section, survey_date = month_end_date, object_id = blob_end,
              area_m2 = area_end_m2, species, plot_area_m2)
) |> distinct()

# Split/fuse rows may repeat the same measured object. Require repeated values
# to agree before collapsing; conflicting area or species is not averaged.
plot_e_cover_object_checks <- plot_e_cover_snapshots |>
  count(plot_section, survey_date, object_id, name = "n_distinct_measurements")
stopifnot(all(plot_e_cover_object_checks$n_distinct_measurements == 1L),
          all(!is.na(plot_e_cover_snapshots$area_m2)),
          all(plot_e_cover_snapshots$area_m2 > 0))

# 2. Assign ancestry to current objects, not to duplicated original histories ----
plot_e_cover_membership <- plot_e_object_lineage_tracking |>
  filter(n_living_descendants > 0L) |>
  select(plot_section, survey_date, cohort, living_descendant_ids) |>
  tidyr::separate_rows(living_descendant_ids, sep = ";") |>
  rename(object_id = living_descendant_ids) |>
  distinct(plot_section, survey_date, object_id, cohort) |>
  group_by(plot_section, survey_date, object_id) |>
  summarise(n_cohorts = n(),
            cohort = if (n() == 1L) first(cohort) else "Mixed cohorts",
            .groups = "drop")

plot_e_cohort_cover_objects <- plot_e_cover_snapshots |>
  left_join(plot_e_cover_membership, by = c("plot_section", "survey_date", "object_id")) |>
  mutate(cohort = coalesce(cohort, "Unassigned"),
         n_cohorts = coalesce(n_cohorts, 0L),
         cohort = factor(cohort, levels = plot_e_cover_cohort_order)) |>
  arrange(survey_date, cohort, plot_section, object_id)
stopifnot(nrow(plot_e_cohort_cover_objects) == nrow(plot_e_cover_snapshots))

# 3. Summarize area and cover. No area is replicated per original ancestor ----
plot_e_cohort_cover_summary <- plot_e_cohort_cover_objects |>
  group_by(survey_date, cohort) |>
  summarise(n_current_objects = n(), total_outplant_area_m2 = sum(area_m2),
            plot_area_m2 = first(plot_area_m2), .groups = "drop") |>
  mutate(percent_outplant_cover = 100 * total_outplant_area_m2 / plot_area_m2)

# The existing E species display excludes Empty and unidentified labels. Keep
# that display rule without changing the total-area and cover calculations.
plot_e_cohort_species_area <- plot_e_cohort_cover_objects |>
  filter(!is.na(species), !species %in% c("Empty", "Unidentified coral")) |>
  group_by(survey_date, cohort, species) |>
  summarise(total_outplant_area_m2 = sum(area_m2), .groups = "drop")

# Requested display: the two documented cohorts only. Other measured objects
# remain in the audit tables and reconciliation, but not in these figures.
plot_e_cohort_cover_display <- plot_e_cohort_cover_summary |>
  filter(cohort %in% plot_e_cover_cohort_order[1:2])
plot_e_cohort_species_display <- plot_e_cohort_species_area |>
  filter(cohort %in% plot_e_cover_cohort_order[1:2])

# 4. Reconcile every survey with the unchanged measured total ----
plot_e_cohort_cover_checks <- plot_e_cohort_cover_summary |>
  group_by(survey_date) |>
  summarise(partition_area_m2 = sum(total_outplant_area_m2), .groups = "drop") |>
  left_join(outplant_cover_summary |>
              filter(plot == "Plot E") |>
              select(survey_date, measured_total_area_m2 = total_outplant_area_m2),
            by = "survey_date") |>
  mutate(difference_m2 = partition_area_m2 - measured_total_area_m2)
stopifnot(all(!is.na(plot_e_cohort_cover_checks$measured_total_area_m2)),
          all(abs(plot_e_cohort_cover_checks$difference_m2) < 1e-10))

# 5. Save audit tables ----
write_csv(plot_e_cohort_cover_objects,
          file.path(plot_e_cover_output_dir, "plot_e_cohort_cover_objects.csv"))
write_csv(plot_e_cohort_cover_summary,
          file.path(plot_e_cover_output_dir, "plot_e_cohort_cover_summary.csv"))
write_csv(plot_e_cohort_species_area,
          file.path(plot_e_cover_output_dir, "plot_e_cohort_species_area.csv"))
write_csv(plot_e_cohort_cover_checks,
          file.path(plot_e_cover_output_dir, "plot_e_cohort_cover_checks.csv"))
