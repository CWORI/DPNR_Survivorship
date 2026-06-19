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

Contributors may record proposed rows in the matching config inside the Teams
intake copy of the project. The project curator should review and copy only the
new approved rows into the official local Git clone after running `git pull`.
Do not replace an official local config with the complete Teams copy, and do not
render or publish the Teams intake copy as though it were the GitHub project.

After GitHub changes the config structure or templates, reconcile all pending
Teams submissions before refreshing the Teams intake configs from GitHub. Never
overwrite unreviewed contributor rows during that refresh.
