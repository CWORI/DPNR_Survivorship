# DPNR Outplant Analyses

This project analyzes coral outplant survivorship, cover, and species composition from TagLab match CSV files.

## How to Run

1. Put the full `Coral_survivorship_project` folder anywhere on your computer.
2. Open `CWORI_RStudio.Rproj` in RStudio.
3. Open `coral_survivorship_report.qmd`.
4. Click Render.

The report and R script automatically find the project folder by looking for `config/outplant_interval_files/`, so users should not need to edit hard-coded working-directory paths.

## Main Files

- `coral_survivorship_report.qmd`: Quarto report with tabs, figures, tables, and code dropdowns.
- `R/03_outplant_interval_workflow.R`: main analysis workflow.
- `config/outplant_interval_files/`: one user-editable TagLab match-file list per plot (`Plot_A.csv` through `Plot_H.csv`).
- `data_raw/taglab/`: raw TagLab match files.
- `data_processed/outplant_master_tracking_dataset.csv`: recommended detailed output dataset.
- `outputs/Tables/outplant_master_summary_dataset.csv`: recommended summary output dataset.

## Adding New Plot or Month Files

1. Add the new TagLab match CSV file to the correct folder inside `data_raw/taglab/`.
2. Add a matching row to that plot's CSV inside `config/outplant_interval_files/`.
3. Render `coral_survivorship_report.qmd`.
4. Check the file audit and QA/QC tables before interpreting the figures.
