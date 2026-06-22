library(tidyverse)
library(readxl)
library(janitor)

# Project root -----------------------------------------------------------------
all_coral_find_project_root <- function() {
  source_path <- tryCatch(
    normalizePath(sys.frame(1)$ofile, mustWork = TRUE),
    error = function(e) NA_character_
  )
  rscript_arg <- commandArgs(trailingOnly = FALSE) %>%
    str_subset("^--file=") %>%
    str_remove("^--file=") %>%
    first(default = NA_character_)
  rscript_path <- tryCatch(
    normalizePath(rscript_arg, mustWork = TRUE),
    error = function(e) NA_character_
  )

  candidate_dirs <- c(dirname(source_path), dirname(rscript_path), getwd()) %>%
    discard(is.na) %>%
    unique()

  for (candidate_dir in candidate_dirs) {
    current_dir <- candidate_dir
    repeat {
      if (dir.exists(file.path(current_dir, "config", "all_coral_survey_files"))) {
        return(current_dir)
      }
      parent_dir <- dirname(current_dir)
      if (identical(parent_dir, current_dir)) break
      current_dir <- parent_dir
    }
  }

  stop(
    "Could not find config/all_coral_survey_files/. Open the ",
    "Coral_survivorship_project folder and try again.",
    call. = FALSE
  )
}

all_coral_project_root <- all_coral_find_project_root()
setwd(all_coral_project_root)

# Paths ------------------------------------------------------------------------
all_coral_config_path <- file.path("config", "all_coral_survey_files")
all_coral_raw_dir <- file.path("data_raw", "All_Coral")
all_coral_processed_dir <- file.path("data_processed", "all_corals")
all_coral_table_dir <- file.path("outputs", "Tables", "all_corals")
all_coral_figure_dir <- file.path("outputs", "Figures", "all_corals")

dir.create(all_coral_processed_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(all_coral_table_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(all_coral_figure_dir, recursive = TRUE, showWarnings = FALSE)

# Helpers ----------------------------------------------------------------------
all_coral_normalize_plot <- function(x) {
  x %>%
    as.character() %>%
    str_squish() %>%
    str_replace_all("_", " ") %>%
    str_to_title()
}

all_coral_clean_species <- function(x) {
  x %>%
    as.character() %>%
    str_squish() %>%
    str_replace_all("_", " ") %>%
    str_to_sentence() %>%
    na_if("")
}

all_coral_area_to_m2 <- function(area, units) {
  case_when(
    units == "cm2" ~ area / 10000,
    units == "mm2" ~ area / 1000000,
    units == "m2" ~ area,
    TRUE ~ NA_real_
  )
}

all_coral_section_from_image <- function(image_name) {
  str_extract(basename(image_name), "[0-9]+-[0-9]+(?=\\.tif$)")
}

all_coral_collapse <- function(x) {
  x <- sort(unique(na.omit(as.character(x))))
  if (length(x) == 0) "" else paste(x, collapse = "; ")
}

all_coral_plot_theme <- function() {
  theme_minimal(base_size = 11) +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(color = "grey35"),
      axis.title = element_text(face = "bold"),
      axis.text = element_text(color = "grey15"),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      legend.position = "right"
    )
}

# Config -----------------------------------------------------------------------
all_coral_read_config <- function(path) {
  config_files <- list.files(
    path,
    pattern = "^Plot_[A-H]\\.csv$",
    full.names = TRUE
  ) %>% sort()

  raw_config <- map_dfr(config_files, function(config_file) {
    read_csv(
      config_file,
      show_col_types = FALSE,
      col_types = cols(.default = col_character())
    ) %>%
      clean_names() %>%
      mutate(config_file = basename(config_file))
  })

  required_columns <- c(
    "plot", "plot_folder", "year", "file", "sheet", "survey_date",
    "plot_length_m", "plot_width_m", "taglab_area_units",
    "expected_sections"
  )
  missing_columns <- setdiff(required_columns, names(raw_config))
  if (length(missing_columns) > 0) {
    stop(
      "All-coral config files are missing columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  raw_config %>%
    filter(!is.na(file), str_squish(file) != "") %>%
    mutate(
      plot = all_coral_normalize_plot(plot),
      year = parse_integer(year),
      survey_date = as.Date(survey_date),
      plot_length_m = parse_double(plot_length_m),
      plot_width_m = parse_double(plot_width_m),
      plot_area_m2 = plot_length_m * plot_width_m,
      taglab_area_units = str_to_lower(str_squish(taglab_area_units)),
      path = file.path(all_coral_raw_dir, plot_folder, year, file)
    ) %>%
    arrange(plot, survey_date)
}

all_coral_build_file_audit <- function(config) {
  config %>%
    transmute(
      plot, survey_date, file, sheet, path,
      file_exists = file.exists(path),
      file_size_kb = if_else(file_exists, round(file.size(path) / 1024, 1), NA_real_)
    )
}

# Workbook reader --------------------------------------------------------------
all_coral_read_survey <- function(config_row) {
  path <- config_row$path[[1]]
  sheet <- config_row$sheet[[1]]

  if (!file.exists(path)) {
    stop("Configured all-coral workbook does not exist: ", path, call. = FALSE)
  }

  raw <- read_excel(path, sheet = sheet) %>%
    clean_names()

  required_columns <- c(
    "image_name", "tag_lab_date", "tag_lab_type", "tag_lab_genet_id",
    "tag_lab_id", "tag_lab_class_name", "tag_lab_area"
  )
  missing_columns <- setdiff(required_columns, names(raw))
  if (length(missing_columns) > 0) {
    stop(
      basename(path), " is missing columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  raw %>%
    transmute(
      plot = config_row$plot[[1]],
      survey_date = config_row$survey_date[[1]],
      source_file = config_row$file[[1]],
      image_name = as.character(image_name),
      plot_section = all_coral_section_from_image(image_name),
      taglab_date = as.Date(tag_lab_date),
      taglab_type = as.character(tag_lab_type),
      genet_id = as.character(tag_lab_genet_id),
      annotation_id = as.character(tag_lab_id),
      species_raw = as.character(tag_lab_class_name),
      species = all_coral_clean_species(tag_lab_class_name),
      area_raw = parse_double(as.character(tag_lab_area)),
      taglab_area_units = config_row$taglab_area_units[[1]],
      area_m2 = all_coral_area_to_m2(area_raw, taglab_area_units),
      plot_length_m = config_row$plot_length_m[[1]],
      plot_width_m = config_row$plot_width_m[[1]],
      plot_area_m2 = config_row$plot_area_m2[[1]],
      expected_sections = config_row$expected_sections[[1]],
      is_coral = !is.na(species) & str_to_lower(species) != "empty"
    )
}

# Build ------------------------------------------------------------------------
all_coral_config <- all_coral_read_config(all_coral_config_path)
all_coral_file_audit <- all_coral_build_file_audit(all_coral_config)

if (any(!all_coral_file_audit$file_exists)) {
  stop(
    "One or more all-coral workbooks are missing. Check ",
    "outputs/Tables/all_corals/all_coral_file_audit.csv.",
    call. = FALSE
  )
}

all_coral_observations <- map_dfr(
  seq_len(nrow(all_coral_config)),
  ~ all_coral_read_survey(all_coral_config[.x, , drop = FALSE])
)

# QA ---------------------------------------------------------------------------
all_coral_survey_qa <- all_coral_observations %>%
  group_by(plot, survey_date, source_file) %>%
  summarise(
    n_annotation_rows = n(),
    n_images = n_distinct(image_name),
    observed_sections = all_coral_collapse(plot_section),
    expected_sections = first(expected_sections),
    missing_sections = {
      expected <- str_split(first(expected_sections), ";", simplify = TRUE) %>%
        as.character() %>% str_squish()
      all_coral_collapse(setdiff(expected, unique(plot_section)))
    },
    taglab_dates = all_coral_collapse(taglab_date),
    n_date_mismatches = sum(!is.na(taglab_date) & taglab_date != survey_date),
    n_missing_species = sum(is.na(species)),
    n_missing_area = sum(is.na(area_raw)),
    n_nonpositive_area = sum(!is.na(area_raw) & area_raw <= 0),
    n_duplicate_annotation_ids = sum(duplicated(paste(image_name, annotation_id))),
    .groups = "drop"
  )

all_coral_section_qa <- all_coral_observations %>%
  group_by(plot, survey_date, source_file, plot_section) %>%
  summarise(
    n_annotation_rows = n(),
    n_unique_annotation_ids = n_distinct(annotation_id),
    n_unique_genet_ids = n_distinct(genet_id),
    total_annotated_area_m2 = sum(area_m2[is_coral], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    genet_id_warning = n_annotation_rows > 1 & n_unique_genet_ids <= 1
  )

# Cover summaries --------------------------------------------------------------
all_coral_cover_summary <- all_coral_observations %>%
  filter(is_coral, !is.na(area_m2)) %>%
  group_by(plot, survey_date) %>%
  summarise(
    plot_length_m = first(plot_length_m),
    plot_width_m = first(plot_width_m),
    plot_area_m2 = first(plot_area_m2),
    taglab_area_units = first(taglab_area_units),
    n_annotations = n(),
    n_species_classes = n_distinct(species),
    total_coral_area_m2 = sum(area_m2),
    percent_coral_cover = 100 * total_coral_area_m2 / first(plot_area_m2),
    .groups = "drop"
  )

all_coral_species_cover_summary <- all_coral_observations %>%
  filter(is_coral, !is.na(area_m2)) %>%
  group_by(plot, survey_date, species, plot_area_m2) %>%
  summarise(
    n_annotations = n(),
    species_area_m2 = sum(area_m2),
    .groups = "drop"
  ) %>%
  group_by(plot, survey_date) %>%
  mutate(
    percent_plot_cover = 100 * species_area_m2 / plot_area_m2,
    percent_of_coral_cover = 100 * species_area_m2 / sum(species_area_m2)
  ) %>%
  ungroup()

# Figures ----------------------------------------------------------------------
all_coral_cover_plot <- ggplot(
  all_coral_cover_summary,
  aes(x = survey_date, y = percent_coral_cover, color = plot, group = plot)
) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2.6) +
  geom_text(
    aes(label = sprintf("%.2f%%", percent_coral_cover)),
    vjust = -0.8,
    size = 3,
    show.legend = FALSE
  ) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b\n%Y") +
  scale_y_continuous(labels = scales::label_number(accuracy = 0.1), expand = expansion(mult = c(0.05, 0.16))) +
  labs(
    title = "Whole-plot coral cover through time",
    subtitle = "All TagLab coral annotations; Empty labels excluded",
    x = "Survey date",
    y = "Coral cover (%)",
    color = "Plot"
  ) +
  all_coral_plot_theme()

all_coral_top_species <- all_coral_species_cover_summary %>%
  group_by(species) %>%
  summarise(total_area_m2 = sum(species_area_m2), .groups = "drop") %>%
  slice_max(total_area_m2, n = 8, with_ties = FALSE) %>%
  pull(species)

all_coral_species_plot_data <- all_coral_species_cover_summary %>%
  mutate(species_group = if_else(species %in% all_coral_top_species, species, "Other coral classes")) %>%
  group_by(plot, survey_date, species_group) %>%
  summarise(percent_plot_cover = sum(percent_plot_cover), .groups = "drop")

all_coral_species_cover_plot <- ggplot(
  all_coral_species_plot_data,
  aes(x = survey_date, y = percent_plot_cover, fill = species_group)
) +
  geom_area(alpha = 0.9, color = "white", linewidth = 0.15) +
  facet_wrap(~ plot, scales = "free_x") +
  scale_x_date(date_breaks = "2 months", date_labels = "%b\n%Y") +
  scale_y_continuous(labels = scales::label_number(accuracy = 0.1), expand = expansion(mult = c(0, 0.05))) +
  labs(
    title = "Coral cover by species through time",
    subtitle = "Eight largest species groups shown separately",
    x = "Survey date",
    y = "Plot cover (%)",
    fill = "Species"
  ) +
  all_coral_plot_theme()

# Write outputs ----------------------------------------------------------------
write_csv(
  all_coral_observations,
  file.path(all_coral_processed_dir, "all_coral_observations.csv.gz")
)

walk2(
  list(
    all_coral_file_audit,
    all_coral_survey_qa,
    all_coral_section_qa,
    all_coral_cover_summary,
    all_coral_species_cover_summary
  ),
  c(
    "all_coral_file_audit",
    "all_coral_survey_qa",
    "all_coral_section_qa",
    "all_coral_cover_summary",
    "all_coral_species_cover_summary"
  ),
  ~ write_csv(.x, file.path(all_coral_table_dir, paste0(.y, ".csv")))
)

ggsave(
  file.path(all_coral_figure_dir, "all_coral_cover_over_time_plot.png"),
  all_coral_cover_plot,
  width = 8,
  height = 5,
  dpi = 300
)
ggsave(
  file.path(all_coral_figure_dir, "all_coral_species_cover_over_time_plot.png"),
  all_coral_species_cover_plot,
  width = 9,
  height = 5.5,
  dpi = 300
)

message("Built all-coral cover workflow outputs.")
