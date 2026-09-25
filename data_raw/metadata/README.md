# Spatial and outplant metadata

## GPS coordinate source

`Plot_Map_GPS_Points.csv` is the coordinate and depth table supplied by Spencer
Parr on 2026-09-25. The file is preserved unchanged from
`Plot Map + GPS Points(Coordinates + Depths).csv` in Downloads.

Fields:

- `id`: original site or Coki identifier.
- `id_new`: revised public identifier.
- `marker`: corner marker (`M1` through `M4`) or named reference point.
- `lat`, `lon`: latitude and longitude in decimal degrees.
- `depth (ft)`, `depth (m)`: supplied depths in feet and metres.

The interactive map assumes the latitude and longitude values use WGS 84
(EPSG:4326). Coki polygons use markers M1, M2, M3, and M4 in that order, which
matches the supplied field-layout diagram. The source also contains control,
nursery, dock, tree, pipe, and Sea Trek reference points. Those rows are
preserved but are not included in the website's Coki A-H polygon layer.

These are field GPS positions collected around small underwater plots. Their
accuracy is limited by the source GPS measurements and should not be treated as
survey-grade cadastral boundaries. The analysis uses the confirmed 16 by 30 m
(480 m²) plot area for cover percentages; it does not infer plot area from the
GPS polygons.

## Other metadata

`Coordinates_Depths.csv`, `Master Outplant Log(2026).csv`, and `genet data.csv`
are retained as existing project metadata. The current interactive map workflow
does not modify them.
