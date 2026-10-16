# DPNR Outplant Analyses

This project analyzes coral outplant survivorship, cover, and species composition from TagLab match CSV files.

## How to Run

1. Put the full `Coral_survivorship_project` folder anywhere on your computer.
2. Open `CWORI_RStudio.Rproj` in RStudio.
3. Open `coral_survivorship_report.qmd`.
4. Click Render.

The report and R script automatically find the project folder by looking for `config/outplant_interval_files/`, so users should not need to edit hard-coded working-directory paths.

If rendering from the Terminal is easier, use the Quarto copy bundled with RStudio:

```bash
/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto render
```

The easiest local render command is:

```bash
bash scripts/render_site.sh
```

That command renders the real project root and checks that the custom homepage
was written to `docs/index.html`.

## Main Files

- `coral_survivorship_report.qmd`: Quarto report with tabs, figures, tables, and code dropdowns.
- `index.qmd`: homepage with the interactive GPS map of Coki A-H and monitoring summaries.
- `R/03_outplant_interval_workflow.R`: main analysis workflow.
- `R/05_interactive_coki_map.R`: builds the Coki polygons, popup summaries, and map outputs.
- `config/outplant_interval_files/`: one user-editable TagLab match-file list per plot (`Plot_A.csv` through `Plot_H.csv`).
- `data_raw/taglab/`: raw TagLab match files.
- `data_processed/outplant_master_tracking_dataset.csv`: recommended detailed output dataset.
- `outputs/Tables/outplant_master_summary_dataset.csv`: recommended summary output dataset.
- `data_processed/coki_plot_polygons.geojson`: reusable GPS-defined Coki boundaries.
- `outputs/Tables/coki_interactive_map_summary.csv`: monitoring values displayed in the map popups.

## Adding New Plot or Month Files

1. Anyone working on TagLab uploads new exports to the appropriate Teams folder under `Documents > General > Photogrammetry & Monitoring > Survivorship Exports`.
2. Add the file information to the appropriate plot config inside the Teams project copy.
3. Let Spencer know the files and config rows are ready.
4. Spencer runs `git pull` in the local Git project.
5. Spencer copies the matches CSVs and new config rows into the local project.
6. Render `coral_survivorship_report.qmd`.
7. Check the file audit and QA/QC tables before committing and pushing the update.
8. Run `Rscript scripts/pre_push_check.R` before pushing to confirm the rendered website and main outputs are present.

See the detailed **SOP** tab in the website for the full Teams-to-GitHub steps.

## Before Pushing to GitHub

Run this quick check from the project folder:

```bash
Rscript scripts/pre_push_check.R
```

The check confirms the expected GitHub remote, important rendered pages, main output tables, and QA file-audit results. It also prints the current Git status so it is clear what still needs to be staged or committed.

## September 23, 2026 data refresh

The active TagLab inputs are 91 user-supplied exports in `data_raw/taglab/`:
42 from `Downloads/Matches/`, 40 Plot E exports from
`OneDrive_1_9-23-2026.zip`, and nine Plot F exports supplied on September 29.
All input bytes are preserved; source paths, row counts, and SHA-256 hashes are
recorded in `logs/2026-09-23_data_intake.csv` and
`logs/2026-09-29_plot_f_data_intake.csv`.
Superseded C, E, and G inputs and the previous configs are retained only in
`archive/2026-09-23_superseded/`; the workflow never reads that directory.

Plots A, B, C, G, and H extend through August 2026; D extends through June 2026.
Plot E sections 0-0 and 0-1 extend through May 2026, while 1-0 and 1-1 end in
January 2026. Full-plot cumulative survival requires all configured sections;
later E cover, interval survival, and species summaries use only available
sections. Plot F was added on September 29, 2026 with three configured sections
through August 20, 2026. No observations were fabricated.

The user confirmed 16 by 30 m plot dimensions (480 m²). The existing cm² TagLab
area convention is retained. See `data_raw/taglab/README.md` for fields and caveats.
The website now includes populated tabs for all eight plots; the
all-coral and temperature sources were not replaced because no updates were supplied.

QA found five Plot E Genets with changing species labels and shared-month
continuity differences. These are preserved and exposed in the report, not
silently corrected. Rerun with `bash scripts/render_site.sh`, then run
`Rscript scripts/pre_push_check.R` before publishing.

## Website presentation

Each populated plot tab displays its own figures, including Plot E. Source-file
lists and QA/QC tables are collapsed in expandable details. Each available plot
also has a total **outplant** cover bar chart by exact survey date, calculated
from the existing summed outplant areas divided by 480 m². These charts do not
include non-outplanted colonies. Amber bars indicate partial section coverage;
missing sections are not filled with zeros. The homepage omits the workflow/site-count tiles
and the Publish Check card; the local validation script remains available.

All time-based figure axes use exact survey dates in day-month-year format.
This keeps multiple surveys from the same named month at separate x positions,
including Coki F surveys on May 1 and May 27, 2026.

Each Coki tab also shows absolute measured outplant area by species and partitions
each monitoring cycle into area added by TagLab `born` outplants, area gained from
growth, and area lost through shrinkage or mortality. The partition sums exactly
to the measured interval-area change. All current `born` Genets are first
appearances, but the classification does not independently verify deployment logs.
Genotype charts are not generated because the current TagLab exports contain no
non-missing genotype values.

The homepage rebuilds the existing Matches workflow and summarizes the latest
complete-section cumulative-survival result per plot. Its overall count sums
baseline Genets once per plot; it is not the historical number of planted
fragments or a count of later additions. Cards show survey dates, baseline counts,
survivor counts, and percentages. Different plots can have different latest dates.

## Interactive Coki map

The website homepage includes a zoomable map of Coki A-H built from the four GPS corner
markers supplied for each Coki. Clicking a boundary shows the latest outplant
count, species counts, observed outplant area, percent of the confirmed 480 m²
Coki area, survey coverage, and the latest complete-section cumulative
survivorship result. The source coordinates and
their limitations are documented in `data_raw/metadata/README.md`.

## October 16, 2026: Coki E refresh

Coki E now uses 64 user-supplied matches exports from
`/Users/spencerparr/Downloads/OneDrive_1_10-16-2026/`, including corrected
1-1 filenames. All four sections extend from May 7, 2025 to September 1, 2026.
SHA-256 hashes and row counts are in `logs/2026-10-16_plot_e_data_intake.csv`.
The previous E raw inputs and config are preserved in
`archive/2026-10-16_plot_e_pre_refresh/`.

Only the E report section has revised figures. Its main survival chart omits
temperature. The first session chart ends March 25, 2026. The second starts
April 9 and compares the original May 7 baseline Genets with Genets first
observed April 9 and never present earlier. These are operational TagLab
cohorts; deployment identity is not independently verified. Original-cohort
survival retains the 2025 denominator in April. Both use the existing absorbing
loss convention (absence ends survival, even if a Genet reappears). IDs are
section-prefixed. Cohort counts and percentages are exported to
`outputs/Tables/plot_e_outplant_cohort_survival.csv` by the report.

E species figures/table exclude Empty and unidentified labels, recalculate
composition percentages, and show only observed legend categories. Raw records
and overall survival/cover calculations retain those labels. The original
plotting palette used `drop = FALSE`, which displayed unused categories.
The initial blue area bar uses measured standing area on May 7, 2025, not
unavailable deployment-day measurements. Later bars retain interval changes.
Rerun with `quarto render coral_survivorship_report.qmd`; the shared pipeline
rebuilds its existing outputs, with non-E analysis definitions unchanged.

## October 16, 2026: Original Genet tracking audit

Checked all shared-survey blob IDs: no conflicting Genet assignments. No
original-cohort Genets reappear after absence. At the last survey, 137 of 412
original IDs are present, 227 have explicit dead records, and 48 are unresolved
absences. The report now distinguishes these statuses and exports per-ID and
per-survey tracking audits under outputs/Tables/plot_e_original_genet_tracking*.csv.
No unsupported ID remapping or imputed survival was applied. Added percentage
labels to every point in both E cohort figures.
