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
