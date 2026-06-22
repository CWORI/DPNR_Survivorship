# All-Coral Survey Config Files

These config files control the whole-plot coral-cover workflow. Use one CSV per
plot and add one row for every survey workbook.

The raw Excel workbooks belong under:

`data_raw/All_Coral/Plot_<letter>/<year>/`

The workflow reads the raw annotation sheet named in `sheet`; it does not use
the workbook pivot tables. Keep `expected_sections` separated by semicolons.

`taglab_area_units` must describe the exported TagLab area values. The current
practice data use `cm2`, and Plot E is configured as a 16 by 30 m plot.
