# Change record

## 2026-09-23 — TagLab intake and website refresh

- Imported 82 original CSVs (9,329 rows), preserving bytes and recording source paths and SHA-256 checksums in `2026-09-23_data_intake.csv`.
- Moved prior `data_raw/taglab/Plot_C`, `Plot_E`, and `Plot_G` directories to `archive/2026-09-23_superseded/Plot_C`, `Plot_E`, and `Plot_G`; copied previous configs there before replacing active configs for A/B/C/D/E/G/H.
- All new source files retain their original filenames; only the parent directory changes to the corresponding `data_raw/taglab/Plot_<letter>/`.
- Populated website tabs for A/B/D/H, expanded overview plots to all available plots, refreshed existing tabs and homepage, and added coverage and QA notes.
- Retained the existing analytical methods and cm² convention, with user-confirmed 16 × 30 m plot dimensions.
- Preserved existing all-coral, temperature, and metadata inputs; none were superseded by this intake.
- Rebuilt derived data, figures, tables, and the Quarto website. See the dated render and validation logs for observed outcomes.
- Preserved `docs/.nojekyll` after Quarto cleanup and updated the render helper to recreate the GitHub Pages marker on future renders.

## 2026-09-23 — Website presentation follow-up

- Added full figures to Plot E's own tab and total outplant cover bars to each of the seven populated plot tabs, using exact survey dates and explicit partial-section labels.
- Collapsed each plot's Data Status and QA/QC contents into native expandable details.
- Removed the two requested homepage metric tiles and the Publish Check card; adjusted the remaining cards to two columns.
- Preserved source data and the existing numerical analysis.
- Validation: successful three-page render and pre-push check; 49 report images loaded, 16 detail panels initially collapsed, Plot E source-file dropdown tested. Raw data and numerical output tables remain unchanged.

## 2026-09-23 — Homepage monitoring overview

- Replaced the homepage introductory sentence with plain language.
- Replaced administrative metrics with baseline outplant total and monitored plot count.
- Added dynamic cards for each plot's latest complete-section survivorship, baseline/survivor counts, and survey date; documented scope and partial-coverage limitations.

## 2026-09-23 — Plot A 0-0 TagLab correction

- Replaced the active Plot A 0-0 series with the corrected TagLab exports supplied in `Downloads/0-0/`.
- Archived the superseded April–June and June–August exports in `archive/2026-09-23_plot_a_0-0_pre_correction/`.
- Updated the intake manifest paths and SHA-256 hashes. The corrected shared April and June snapshots match exactly in Genet, species, and area.
- Rebuilt the derived datasets and website. Plot A now retains 43 of 43 baseline outplants through August (100% cumulative survivorship); cover is 0.0111% in April, 0.0116% in June, and 0.0157% in August.
- Validation confirmed that no non-Plot-A output-table rows changed and the project pre-push check passed.

## 2026-09-23 — Chart label readability

- Added vertical space above the short-monitoring survivorship charts so percentage labels remain visible, including values at 100%.
- Reworked the overview species prevalence and cover charts to use exact survey dates, plot-specific date axes, and uncluttered 0%, 50%, and 100% ticks.
- Increased the rendered height of both overview species figures so all seven plot panels and their labels are readable.
- Rebuilt the workflow outputs and website; the project pre-push check passed.

## 2026-09-23 — Complete species color palette

- Added fixed colors for `Diploria labyrinthiformis`, `Pseudodiploria strigosa`, `Unidentified coral`, and `Empty` while retaining all existing species colors.
- Rebuilt the figures and website so every observed coral-label category has an explicit color.

## 2026-09-24 — Area-source and species-area figures

- Changed cumulative-survivorship date labels from month/day to month/year.
- Added absolute outplant-area line charts by species to the overview and every populated plot tab.
- Added change-source charts that reconcile total-area changes into tracked-coral growth or shrinkage, lost or missing coverage, and new or returned coverage.
- Documented that genotype-area charts cannot yet be calculated because all 7,468 present-outplant records have blank genotype fields.

## 2026-09-25 — Coki display names

- Changed public website tabs, headings, prose, table labels, legends, facets, and axes from Plot A–H to Coki A–H.
- Preserved the internal `Plot A` data identifiers, config filenames, raw-data paths, and code examples so the analysis workflow continues to match the existing files.

## 2026-09-25 — Outplant-cycle area sources

- Reframed the area-change chart around the requested biological questions: area added by outplanting, area gained through coral growth, and area lost through shrinkage or mortality.
- Calculated outplant-added area from 1,528 TagLab `born` records; none had appeared in an earlier interval.
- Verified that the three components sum to the measured interval-area change, within floating-point precision.

## 2026-09-25 — Interactive Coki map

- Added a zoomable Leaflet map of Coki A-H using the four supplied GPS corner markers for each boundary.
- Added satellite and street-map layers, persistent Coki labels, optional corner markers, hover highlighting, and clickable monitoring summaries.
- Popup summaries report the latest outplant count and species counts, observed outplant area, percent of the confirmed 480 m² Coki area, survey coverage, and latest complete-section cumulative survivorship.
- Preserved all supplied control and reference-site coordinates in the reviewed metadata CSV; the website polygon layer uses Coki A-H only.
- Added reusable GeoJSON and CSV map outputs and included them in the pre-push validation.

## 2026-09-25 — Homepage map presentation

- Moved the interactive Coki map onto the homepage and removed its separate navigation tab.
- Increased the map height to provide a larger, more square viewing area.
- Kept satellite imagery visible past its native zoom limit by enlarging the highest-resolution available tiles instead of requesting unavailable tiles that display as gray.

## 2026-09-29 — Plot F data update

- Added nine supplied Plot F Matches exports for sections 0-0, 0-1, and 1-0, covering November 6, 2025 through August 20, 2026.
- Preserved the supplied CSV bytes and recorded source paths, raw row counts, and SHA-256 hashes in `2026-09-29_plot_f_data_intake.csv`.
- Populated Coki F across the report, homepage summary, figures, tables, and interactive-map popup.
- Retained ten comma-only rows and two empty trailing columns in the supplied August 0-1 source file; generated QA reports these as missing rows.

## 2026-09-29 — Exact survey-date axes

- Changed every time-based outplant and all-coral figure to label the x-axis with exact day-month-year survey dates.
- Added survey dates to the outplant cover summary so surveys in the same named month remain separate.
- Changed interval labels to show exact start and end dates and changed short-monitoring labels to show the exact survey date.
- Added a version query to rendered figure URLs so browsers replace cached month-only SVGs with the corrected exact-date figures.

## 2026-09-29 — Plot F species correction

- Replaced the supplied Plot F section 1-0 baseline export with the corrected file.
- Corrected Genet 35 from `Orbicella sp.` to `Orbicella annularis`; all other supplied fields and rows are unchanged.
- Updated the intake SHA-256 hash and rebuilt the website outputs.

## 2026-09-29 — Plot D data update

- Replaced the supplied Plot D Matches exports for sections 0-0, 0-1, and 1-0 with the updated files.
- Added the June 8 to August 6, 2026 interval for sections 0-0 and 1-0; no August interval was supplied for section 0-1, so August remains a partial-section survey.
- Recorded source paths, raw row counts, and SHA-256 hashes in `2026-09-29_plot_d_data_intake.csv`.
- Rebuilt the website outputs, figures, tables, homepage summary, and interactive-map popup.

## 2026-10-09 — Actual Plot A all-coral data intake

- Preserved six original section CSVs for November 14, 2025 and April 21, 2026;
  source paths, counts, and SHA-256 hashes are in `2026-10-09_plot_a_all_coral_intake.csv`.
- Added CSV reading alongside Excel support and combined section checks by survey.
- Updated the all-coral report to count survey dates rather than source files.
- Archived the practice Plot E configuration at
  `archive/2026-10-09_all_coral_practice/Plot_E.csv` at the user's request.
  Raw Plot E files remain unchanged; the active config is header-only.
- The user confirmed cm² annotation units and a 425.561 m² Plot A area.
  Activated both surveys with an explicit `plot_area_m2` config field;
  unknown length and width remain missing.
- Preserved previous practice outputs under
  `archive/2026-10-09_all_coral_practice/` before regenerating Plot A outputs.
- Rebuilt the all-coral tables, figures, and `docs/all_coral_cover.html` locally.
  November coral area is 7.114441 m² (1.671779% cover); April coral area is
  8.610416 m² (2.023309% cover). Species sums match total areas and percentages.
  Both surveys have all three expected sections and no date mismatches, missing
  areas, nonpositive areas, or duplicate image/annotation-ID pairs.

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

Validation: report rendered successfully. Original cohort counts match main cumulative survival at every survey. All tracked non-E plot-level output-table rows match HEAD. E species SVG legends omit Empty/unidentified categories; E main SVG has no temperature; April SVG includes both cohort labels. QA retains 24 E Genets with changing species labels and shared-survey continuity flags.

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

## October 21, 2026: Coki E Excel lineage validation

- Created `outputs/Tables/plot_e_lineage_validation.xlsx` with original-object
  histories, real fusion/split examples, shared descendants, raw Matches rows,
  independent checks and review fields for unresolved histories.
- Retained reproducible preparation/build helpers and verification notes under
  `logs/2026-10-21_lineage_validation/`. No raw inputs or analytical results were
  changed by workbook creation.

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

### 2026-10-22 07:37 Pacific/Tahiti: standalone outplant analysis

- Added `CWORI_Outplants_Analyses.R` at the user's requested filename.
  Core object-lineage survivorship (overall/by baseline species), current-object
  cover, area, species prevalence, cohort area/cover and measured area changes
  run directly from raw Matches. Existing website scripts/outputs were not changed.
- Defaults keep results/figures in R; an explicitly configured optional save
  produces one RDS bundle and refuses existing filenames. Portable folder mode
  infers plot, section and dates, requiring confirmed area and units.
- Documented settings, baseline definitions, object-count prevalence, full-plot
  cover denominators, continuity QA and scientific limits in both READMEs.
- Validation: all 117 configured files / eight plots run; Coki E every-date
  lineage denominators and living/dead/unresolved counts match the existing
  lineage export exactly; all 17 E survey areas match existing total cover.
  Cohort area partitions and species prevalence reconcile; six figures render.
  An independent script copy outside the project runs from the 64 real E CSVs
  without config files or previously generated tables. Ten blank trailing F
  rows are reported/excluded; 184 shared-survey object differences remain in QA.
- Baselines for other plots start at first positive-area surveys because their
  initial export source sides contain no living objects. Missing sections never
  imply death; incomplete surveys are excluded from cohort curves and flagged
  in area/cover. No raw data were changed or files archived/renamed.

### 2026-10-22 07:57 Pacific/Tahiti: restore website-equivalent standalone script

- User rejected the first standalone rewrite because its definitions and figures
  differed from the website. Archived that script at
  `archive/2026-10-22_standalone_before_website_restore/CWORI_Outplants_Analyses.R`
  and replaced the active root script at the same requested filename.
- The replacement contains the original website calculation functions and figure
  expressions, including Plot E's latest split/fusion object-lineage tracking,
  two cohorts, cover partitioning, species correction/exclusions, labels and
  stacked cover formatting. Coki G retains its special short monitoring axes.
  Other plots and species composition retain website Genet-group definitions.
- Inputs are a folder or a list of original Matches CSV paths, read directly via
  `read.csv()`. No config CSVs, website source files or generated intermediate
  tables are needed. The confirmed units/dimensions and E dates are top settings.
- Explicit printing in interactive R shows selected figures in RStudio's Plots
  pane; defaults show E's ten figures. All 66 website plot figures are held in
  `figures`. Saving PDFs is optional and no CSV exports are generated.
- Validation against an independent run of the original pipeline: 12 core tables
  match at 1e-12 tolerance; E object histories, survival, cohort cover and species
  area match. All 66 figure layer data and labels match the actual QMD chunks;
  all ten E figures render at website dimensions. A standalone copy outside the
  project reads the 64 original E files and builds its ten figures without
  project configs or website code.
- Updated both READMEs to replace the rejected version's instructions. Existing
  website scripts, raw data, published pages and previously generated results
  were not changed. Temporary validation figures remain outside the project.

### 2026-10-22 08:17 Pacific/Tahiti: replace standalone wrapper with a linear R analysis

- User requested ordinary analysis code with visible calculations and ggplots,
  without a figure collection, plot-selection settings or export framework.
  Rewrote `CWORI_Outplants_Analyses.R` into numbered inline stages using native
  pipes. Input is one editable Matches folder, read directly with `read.csv()`.
- Summary calculations are explicit pipelines. Plot E lineage traversal and
  cohort area audits remain explicit, including the necessary branch/death/gap
  logic. A few repeated statistical/formatting helpers remain near the top.
- Each graph is built with its own ggplot statements and printed as it is made.
  All supplied plots display in RStudio's Plots pane. E graphs are ordinary named
  objects, such as `plot_e_cover_plot` and `plot_e_survival_plot`. Common non-E
  graphs repeat in simple loops; G retains its short-monitoring survival axes.
  No CSVs, PDFs or other derived outputs are written by the script.
- Validation: 12 scientific tables retain their original values; E original
  object histories, survival and cohort area tables are unchanged. All 66 actual
  print calls match the original figure layer data and labels (label ordering
  within an internal labels list is immaterial); ten E graphs render. An
  independent copy using only 64 real E CSVs and no temperature/website files
  prints ten matching E graphs.
- Archived the previous active script to
  `archive/2026-10-22_standalone_before_linear_rewrite/CWORI_Outplants_Analyses.R`,
  added its README, and updated the project/input READMEs. Raw inputs and the
  existing website remain unchanged. Validation graphics are outside the project.


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
