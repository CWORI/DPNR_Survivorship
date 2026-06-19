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

1. Contributors upload new TagLab exports to the appropriate Teams folder under `Documents > General > Photogrammetry & Monitoring > Survivorship Exports`.
2. Contributors record proposed rows in the appropriate plot config inside the Teams intake copy.
3. The project curator runs `git pull` in the official local clone.
4. The curator copies approved matches CSVs into the correct folder inside `data_raw/taglab/`.
5. The curator copies the reviewed new rows into that plot's local CSV inside `config/outplant_interval_files/`.
6. Render `coral_survivorship_report.qmd`.
7. Check the file audit and QA/QC tables before committing and pushing the update.

See the detailed **SOP** tab in the rendered website for the complete Teams-to-GitHub handoff procedure.
