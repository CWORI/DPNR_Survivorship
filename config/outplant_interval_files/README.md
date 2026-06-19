# Outplant Interval Config Files

Use one config file per plot:

- `Plot_A.csv` for Plot A
- `Plot_B.csv` for Plot B
- continue through `Plot_H.csv`

When a new TagLab match file is ready:

1. Put the raw CSV in `data_raw/taglab/Plot_<letter>/`.
2. Open the matching plot config in this folder.
3. Add one row for each month-to-month interval.
4. Keep intervals grouped by `plot_section` and ordered by `month_start_date`.
5. Render `coral_survivorship_report.qmd` and review the file-audit table.

Do not delete or rename the header row. Empty plot config files should contain
the header only until data are available.

The workflow automatically combines all eight plot config files. A file is not
included in the analysis until its row has been added to the appropriate plot
config.

## Teams intake copy

Anyone working on TagLab can record new rows in the matching config inside the
Teams project copy. Once the files are ready, let Spencer know. Spencer will run
`git pull` and copy the new rows into the local Git project. Copy the new rows
rather than replacing the whole local config, and don't render or publish the
Teams copy because it may be a little behind GitHub.

If GitHub changes the config structure or templates, first save any new Teams
rows that are still waiting. Then refresh the Teams configs from GitHub so
nobody's work gets overwritten.
