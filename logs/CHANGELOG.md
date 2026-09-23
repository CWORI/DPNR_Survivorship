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
