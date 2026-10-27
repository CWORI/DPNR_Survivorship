# DPNR Outplant Analyses

This project analyzes coral outplant survivorship, cover, and species composition from TagLab match CSV files.

## Current website method

All A-H website survivorship follows original objects through documented splits and fusions. Stage 03 sources `R/06_outplant_object_lineage.R`. Living descendants, recorded deaths and unresolved connections are separate outcomes. See the October 27 change record below for definitions, outputs, validation and the source rename.

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

## All-coral cover workflow

`R/04_all_coral_cover_workflow.R` runs as seven numbered steps: read survey
configs, check source-file paths, clean annotations, check survey quality, calculate
cover, build figures, and save outputs. Run it with
`Rscript R/04_all_coral_cover_workflow.R` from the project folder. It also supports
`source()` and working directories inside the project. Paths are anchored to the
project root without changing the session working directory.

Inputs are listed in `config/all_coral_survey_files/` and read from
`data_raw/All_Coral/`. Cleaned observations go to `data_processed/all_corals/`,
QA and summaries to `outputs/Tables/all_corals/`, and figures to
`outputs/Figures/all_corals/`. A full run regenerates these outputs.

Cover is summed annotated coral area divided by configured plot area, multiplied
by 100. Empty labels, missing species, and missing converted areas are excluded;
original labels and areas remain in the observations. Duplicate IDs and
nonpositive areas are flagged but retained. Missing sections are flagged, and
the denominator remains the full plot area. Review QA before interpreting cover.
The `n_top_species` setting controls how many species are displayed separately;
it does not change species summary tables.

The all-coral workflow also accepts original section CSV exports. Configure one
row per file, with the same survey date and expected-section list for every
section of a survey. Survey counts use distinct dates, and section QA combines
files before checking coverage. Never configure the combined workbook as well
as its source CSVs. Plot A intake is documented in `data_raw/All_Coral/README.md`.

Plot A all-coral surveys use the user-confirmed 425.561 m² area and cm² TagLab
values. The all-coral config now requires `plot_area_m2` directly; length and
width are optional metadata. This area applies to the all-coral workflow.

The all-coral script also finds the analysis folder when running selected lines
in RStudio: it checks the active script path and the named
`Coral_survivorship_project` child folder of the working directory or its parents.

Species-cover figures use horizontal bars grouped by coral class, with navy
and teal identifying the first two survey dates. The largest eight classes
are shown individually; other classes remain combined for display only.

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

## October 20, 2026: Clarify Coki E survivorship overview

Replaced the E main single-cohort survival figure with separate 2025 and April
2026 cohort lines. Latest labels show retained IDs, each cohort denominator, and
percentages. Captions clarify that 33.3% describes the 2025 cohort only, that
tracking losses are not confirmed mortality, and monitoring durations differ.
No cohort calculations or raw data were changed.

## October 20, 2026: Original-object lineage analysis for Coki E

`R/06_outplant_object_lineage.R` is sourced by the E report section after workflow
03. It reads the actual Matches rows, seeds 795 positive-area May 7 objects
and 1,105 April 9 destination objects without incoming positive-area source
connections, and follows directed blob correspondences through every interval.
Object IDs are scoped to section and survey. Each original object is counted
once while any documented living descendant remains; shared fused descendants
can retain multiple original lineages. Splitting never multiplies originals.
A branch with no correspondence becomes unresolved; death requires explicit
dead records on every terminal branch with no unresolved branch. No inferred
connections, filled areas, or changes to raw files are used. First appearance
is an operational April-cohort definition, not verified deployment identity.

Outputs: `outputs/Tables/plot_e_object_lineage_tracking.csv` (per original object
and survey, descendant IDs, uncertainty) and `plot_e_object_lineage_survival.csv`
(cohort counts and percentages). At September 1: May cohort 383 living, 341
recorded dead, 71 unresolved of 795 (48.2% living); April cohort 924 living, 173
recorded dead, 8 unresolved of 1,105 (83.6% living). Counts reproduce independent
Python traversal of the raw CSVs for every cohort/date. Objects 131 and 136 in
section 0-0 both connect to living September object 1 and count separately.

The October 20 Genet exports contain 10 additional May object IDs not present
in the configured first Matches exports. They are not silently added to these
Matches-based cohorts; the report discloses this source discrepancy. These
objects require reconciled Matches inputs before lineage tracking is possible.
Historical Genet-based audit/cohort outputs are retained but are not inputs to
the revised E cohort figures. Interval survival remains explicitly labeled as
Genet-group retention; cover/species calculations and other plots are unchanged.
Lineage persistence after fusion does not prove persistence of every contributor's
tissue. Confidence intervals assuming independent individuals are omitted.
Existing PDF exports predate this change and are historical, not updated here.

## October 21, 2026: Excel lineage validation

`outputs/Tables/plot_e_lineage_validation.xlsx` contains the 1,900 original-object
histories, real fusion/split worked examples, raw correspondences, shared
ancestry, unresolved-case review fields and independent validation checks.
Rebuild instructions and verification notes are retained under
`logs/2026-10-21_lineage_validation/README.md`. The workbook is an audit snapshot;
editing raw cells in Excel does not reconstruct the tracking graph.

## October 21, 2026: Coki E cover by outplant cohort

Added `R/07_plot_e_cohort_cover.R`, sourced after the E object-lineage stage.
The E cover line chart, total-cover stacked bars and species-area panels now
partition current object area by documented 2025/April 2026 ancestry. Each
section/survey/object contributes its measured area once, regardless of how many
original individuals share it. Objects connected to neither baseline retain an
Unassigned category. Cross-cohort shared descendants would retain Mixed cohorts
rather than being duplicated or allocated using an invented fraction; none are
present in the current data. Species-area panels retain the existing exclusion
of Empty/unidentified labels, while total cover retains all measured objects.

Audit outputs under `outputs/Tables/`: `plot_e_cohort_cover_objects.csv`,
`plot_e_cohort_cover_summary.csv`, `plot_e_cohort_species_area.csv`, and
`plot_e_cohort_cover_checks.csv`. The 39 cohort/date area partitions independently
match raw object measurements; their sums reproduce the existing total cover at
all 17 survey dates. Object area and species must agree across repeated Matches
rows before deduplication. The configured plot-area denominator remains 480 m².

Removed subtitles below the main titles from all ten Coki E figures only.
Methodological explanations remain in report text/captions. Other plot sections
and the shared original analyses are unchanged. Historical PDF exports and the
lineage-validation workbook are separate snapshots, not rebuilt by this edit.

## October 21, 2026: Two-cohort display and PDF refresh

Removed Unassigned from the three Coki E cohort cover/area figures and the
displayed cohort-cover table, without deleting or reallocating its measurements
in the object audit and total-area reconciliation. The displayed bars are now
labeled tracked-cohort cover. All cohort cover areas come from the configured
Matches exports, not the separate All_Coral survey dataset. Updated all ten
current Coki E vector PDFs in `Coki_E_High_Def_PDFs/`, including the revised
object-lineage survival figures and the other report figures. Removed all E
subtitles. Preserved previous PDFs and README by copying them to
`archive/2026-10-21_coki_e_pdfs_before_refresh/`. The PDF export helper is
`logs/2026-10-21_lineage_validation/export_coki_e_pdfs.R`.

## October 21, 2026: Group Coki E cohort-cover bars

Changed `plot-e-total-cover-bars` from stacked to side-by-side bars. Both
cohorts now start at zero so bar height directly indicates that cohort's cover.
No source data, area calculations, or cover values changed. Updated the matching
PDF and preserved its previous stacked version in
`archive/2026-10-21_coki_e_stacked_cover_before_grouping/`. The PDF helper now
supports an optional report chunk label to refresh a selected figure.


### 2026-10-21: confirmed Coki E species identification and figure typography

User confirmed that Coki E annotations labeled Orbicella sp./spp. are
Orbicella faveolata. The Matches processing now applies that identification
only to Plot E, preserving the original exports. The 50 affected source rows
are listed in `logs/2026-10-21_plot_e_species_correction.csv`.
Species names are italicized in Matches figures and in the separate coral-cover
species figure. The three Coki E species PDFs were refreshed; previous versions
are in `archive/2026-10-21_coki_e_species_pdfs_before_correction/`.
This relabels species contributions without changing measured area or object
lineage tracking. All 17 cohort-cover area partitions still reconcile with
measured totals to floating-point precision. These changes are local.


### 2026-10-21: Coki E survivorship figure label cleanup

Removed original-object counts from endpoint labels and removed the bottom
caption from the combined Coki E cohort survivorship figure, as requested.
Monthly percentages and analysis values are unchanged. Refreshed the matching
PDF; prior PDF archived in
`archive/2026-10-21_coki_e_survival_before_label_cleanup/`.


### 2026-10-21: 2025 unresolved lineage review lists

Run `python3 logs/2026-10-21_lineage_validation/list_2025_tracking_gaps.py`
from the project root to generate `outputs/Tables/plot_e_2025_unresolved_originals_review.csv`
(71 final-unresolved originals) and `outputs/Tables/plot_e_2025_taglab_gap_review_tasks.csv`
(51 distinct section/survey-pair/source-object breaks). The task list uses the
last connected survey's object IDs, not May baseline IDs; it records affected
originals and the exact Matches filename. An original can contribute more than
one broken descendant, and multiple originals can share one broken descendant.
The first missing-branch date equals the first no-living-descendant date for
all 71 listed originals. These are export tracking gaps requiring image review,
not confirmed deaths or an explanation of the planting-log/baseline discrepancy.
No raw data or lineage statuses were changed.


### 2026-10-22: Coki E cover figure formatting

The cover line figure now starts its y-axis at zero. Both cover figures label
the cohorts 2025 and 2026. The cover bars are stacked with 2025 at the base
and 2026 above it. No cover values or cohort assignments changed. Refreshed
the two matching high-definition PDFs; prior versions are preserved in
`archive/2026-10-22_coki_e_cover_before_format_update/`.


### 2026-10-23: corrected Coki E Matches intake

Imported all 64 exports from `/Users/spencerparr/Downloads/OneDrive_1_10-23-2026/`;
32 files changed, with 13,171 raw correspondence rows. Source bytes are unchanged.
Five filename/date discrepancies were mapped to configured survey intervals
after the user confirmed those dates, including September 1 rather than
September 8 for the 0-1 final interval. Full source/destination names, hashes,
and dates are recorded in `logs/2026-10-23_plot_e_data_intake.csv`.
Previous inputs, cohort tables, processed Matches tables, validation workbook,
and all ten PDFs were preserved in
`archive/2026-10-23_coki_e_before_corrected_matches/`.

Current final-survey counts: 2025 baseline 796, living 393, recorded dead 378,
unresolved 25 (49.3719% lineage persistence). April baseline 1,103, living 924,
recorded dead 171, unresolved 8 (83.7715%). Of the previous 71 unresolved 2025
originals, 9 now have a living descendant, 37 have complete recorded deaths,
and 25 remain unresolved. The new May baseline includes section 0-0 object153.
April objects340 and341 in section0-0 now have incoming lineage connections
and therefore are not classified as new April additions. The October20 Genet
export comparison now has 9 May objects absent from the Matches baseline.

The report, ten Coki E vector PDFs, validation workbook, and remaining 2025
review lists were regenerated. The 25 unresolved originals correspond to18
distinct source-object gaps. Independent raw-file traversal agrees with all
20,150 saved R individual/date records and all23 cohort/date summaries. All64
current input hashes match intake; all17 cover-area partitions reconcile.
The workbook has no cached formula errors and passes the change/restore check.
These checks validate processing agreement, not the biological accuracy of
every annotation. No tracking gaps were filled or inferred. Nothing was pushed.


### 2026-10-27: final 2025 lineage corrections

Imported the 32 provided exports for sections 1-0 and 1-1 from
`/Users/spencerparr/Downloads/OneDrive_1_10-27-2026/`;10 files changed.
Sections 0-0 and 0-1 retain their October 23 inputs. The complete 64-file intake
manifest, source paths, filenames, hashes, interval dates and retention status
are in `logs/2026-10-27_plot_e_data_intake.csv`. Raw source bytes are preserved.
Incoming filenames have an extra space in section 1-0 and two use February 14
instead of the established February 16 survey date. The January-February file
is byte-identical to the prior February 16 export. Existing configured dates
were retained and those filename differences recorded rather than changing
the survey schedule. Previous data, tables, workbook and PDFs are preserved in
`archive/2026-10-27_coki_e_before_final_corrections/`.

All 25 previously unresolved 2025 originals now resolve:3 have a living
descendant and 22 have complete recorded-death connections. Final 2025 counts
are 796 baseline,396 living,400 recorded dead,0 unresolved,49.7487% lineage
persistence. No 2025 history retains an unresolved branch. April counts are
1,102 baseline,923 living,171 recorded dead,8 unresolved,83.7568% persistence.
April section 1-0 object 713 now has an incoming connection and is no longer
a new-April root. The remaining 8 April gaps span sections 0-0,0-1 and 1-0.
Their review locations are in `outputs/Tables/plot_e_2026_taglab_gap_review_tasks.csv`.
The 2025 review CSVs now contain headers only, reflecting zero unresolved cases.

Rerun review lists with
`python 3 logs/2026-10-21_lineage_validation/list_2025_tracking_gaps.py`
and append `2026` for the April cohort. Independent raw traversal agrees with
all 20,144 original/survey records and all 23 cohort/date summaries. All 64 input
hashes match intake, all 17 measured-cover partitions reconcile, and non-E
processed Matches rows are unchanged. The updated workbook passes its formula
change/restore check and has no cached formula errors. All ten Coki E PDFs
and the report were refreshed and visually checked. The original-versus-planting
inventory question remains separate. These changes have not been committed or pushed.


## 2026-10-27: lineage tracking for every website plot

Stage 03 now sources `R/06_outplant_object_lineage.R`, renamed from
`R/06_plot_e_object_lineage.R`. The E-only implementation is preserved in
`archive/2026-10-27_before_all_plot_lineage/R/`. This is the single active
website lineage implementation for A-H. Each non-E section starts with its
earliest positive-area observed objects. E retains its May 2025 and April 2026
cohorts. Cumulative comparisons require all configured sections. Later additions
do not enter the initial denominator. Missing connections remain unresolved.
A living shared descendant retains each original once, including after splits.

Interval and species-interval survival now count unique source objects, assigning
species at the source survey. Recorded deaths and unresolved outcomes are separate.
Birth counts are new destination objects without living incoming sources, not
independently verified deployments. Independent-binomial confidence limits are
unavailable (NA) because fusion creates shared histories. Measured area and
Genet diagnostics remain separate from survival. The master tracking CSV now
contains original-object histories. The homepage and map use the new summaries
and show E's April cohort separately.

Independent traversal of all 117 raw exports matches 23,530 original/survey
records and 14,102 source-object intervals with zero mismatches. Living plus
recorded-dead plus unresolved counts reconcile to each roster. Latest complete
surveys retain 8 unresolved histories in C and 1 in G; E has 0 unresolved May
histories and 8 unresolved April histories. These are processing checks, not
independent validation of every annotation. Repeat them using
`python3 logs/2026-10-27_all_plot_lineage_validation.py`.

The separate standalone plain-R script was not changed by this website update.
Its earlier E-only description does not describe the website's universal method.
