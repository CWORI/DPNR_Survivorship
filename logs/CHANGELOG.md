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
