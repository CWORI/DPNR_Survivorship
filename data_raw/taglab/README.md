# Active TagLab match exports

Each `Plot_<letter>/` directory contains only the current supplied exports.
Use `config/outplant_interval_files/Plot_<letter>.csv` to select inputs; raw files
are read-only and derived outputs go to `data_processed/` and `outputs/`.
`R/03_outplant_interval_workflow.R` generates those outputs when the report renders.

## Provenance and coverage

September 23, 2026: 42 files from the supplied Matches directory and 40 Plot E files
from OneDrive_1_9-23-2026.zip, totaling 9,329 raw rows. See
`logs/2026-09-23_data_intake.csv` for exact source-to-active-path mapping and hashes.
Old exports are in `archive/2026-09-23_superseded/`, outside the active input path.
A/B/C/G/H end in August 2026, D in June 2026. E spans May 2025–May 2026, but
sections 1-0 and 1-1 stop in January 2026.

September 29, 2026: added nine user-supplied Plot F exports for sections 0-0,
0-1, and 1-0, spanning November 6, 2025 through August 20, 2026. Exact source
paths, row counts, and hashes are recorded in
`logs/2026-09-29_plot_f_data_intake.csv`. One 0-1 export contains two empty
trailing columns and ten comma-only rows; the raw source is preserved and the
generated QA table reports ten comma-only rows as missing values.

## Fields and units

- `Genet`: tracking identifier scoped to its plot and subsection; repeated blob
  rows can represent split/fuse events. Do not join identifiers across sections.
- `Blob1`, `Blob2`: annotation identifiers in the start/end surveys; -1 indicates
  no corresponding annotation. These are identifiers, not measurements.
- `Area1`, `Area2`: start/end annotation areas; configured as cm², retaining the
  project's existing export convention. Zero represents no positive area;
  missing values must not be replaced with zero.
- `Class`: supplied coral species/class label. The established workflow normalizes
  underscores and its documented spelling correction without editing raw inputs.
- `Action`, `Split\Fuse`: supplied matching/event labels.
- Survey dates come from the filename and are stored explicitly in the config.
- Plot dimensions are user-confirmed 16 × 30 m; plot area is 480 m². The workflow
  converts cm² to m² by dividing by 10,000.
- These match tables have no coordinates or CRS; depth/location metadata are
  maintained separately in `data_raw/metadata/Coordinates_Depths.csv`.

## Interpretation limits

The current data contain changing species labels for five Plot E Genets and
shared-survey differences between adjacent exports. Review the generated QA
before interpreting Genet-based cumulative survival. All raw values are retained.
Full-plot cumulative survival includes only dates with every configured section.
Other E summaries after January 2026 describe available sections only; missing
sections are not zero cover or mortality. Source data are not imputed.

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

## October 20, 2026: Original-object lineage analysis for Coki E

`R/06_plot_e_object_lineage.R` is sourced by the E report section after workflow
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


2026-10-21 identification correction: the user identified Coki E Orbicella sp./spp. as Orbicella faveolata. Processing applies the correction to Plot E only; raw exports remain unchanged. See `logs/2026-10-21_plot_e_species_correction.csv` for the 50 source rows.

## Plain R analysis (October 22, 2026)

`../../CWORI_Outplants_Analyses.R` reads original Matches with `read.csv()`.
Set `matches_folder` to the actual input folder and keep original filenames,
which supply plot, section and both YYYYMMDD dates. Confirm the Settings for
plot dimensions, area units and E cohort dates before analysing another study.
There are no config files or generated intermediate inputs to maintain.

The numbered analysis sections contain the actual transformations and ggplot
statements. Each graph is printed to RStudio's Plots pane; no files are saved.
E tracks original object lineages through actual split/fusion edges and keeps
unresolved connections distinct from explicit death. Cohort area is counted
once per measured current object. The established species/ancestry exclusions,
confirmed E Orbicella identification, and other plots' Genet methods are retained.
Raw exports remain unchanged. See the project README for running the script.


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
