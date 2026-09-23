# Active TagLab match exports

Each `Plot_<letter>/` directory contains only the current supplied exports.
Use `config/outplant_interval_files/Plot_<letter>.csv` to select inputs; raw files
are read-only and derived outputs go to `data_processed/` and `outputs/`.
`R/03_outplant_interval_workflow.R` generates those outputs when the report renders.

## Provenance and coverage

September 23, 2026: 42 files from the supplied Matches directory and 40 Plot E files
from OneDrive_1_9-23-2026.zip, totaling 9,329 raw rows. See
`logs/2026-09-23_data_intake.csv` for exact source-to-active-path mapping and hashes.
Old exports are in `archive/2026-09-23_superseded/`, outside the active input path.
A/B/C/G/H end in August 2026, D in June 2026. E spans May 2025–May 2026, but
sections 1-0 and 1-1 stop in January 2026. F has no supplied match files.

## Fields and units

- `Genet`: tracking identifier scoped to its plot and subsection; repeated blob
  rows can represent split/fuse events. Do not join identifiers across sections.
- `Blob1`, `Blob2`: annotation identifiers in the start/end surveys; -1 indicates
  no corresponding annotation. These are identifiers, not measurements.
- `Area1`, `Area2`: start/end annotation areas; configured as cm², retaining the
  project's existing export convention. Zero represents no positive area;
  missing values must not be replaced with zero.
- `Class`: supplied coral species/class label. The established workflow normalizes
  underscores and its documented spelling correction without editing raw inputs.
- `Action`, `Split\Fuse`: supplied matching/event labels.
- Survey dates come from the filename and are stored explicitly in the config.
- Plot dimensions are user-confirmed 16 × 30 m; plot area is 480 m². The workflow
  converts cm² to m² by dividing by 10,000.
- These match tables have no coordinates or CRS; depth/location metadata are
  maintained separately in `data_raw/metadata/Coordinates_Depths.csv`.

## Interpretation limits

The current data contain changing species labels for five Plot E Genets and
shared-survey differences between adjacent exports. Review the generated QA
before interpreting Genet-based cumulative survival. All raw values are retained.
Full-plot cumulative survival includes only dates with every configured section.
Other E summaries after January 2026 describe available sections only; missing
sections are not zero cover or mortality. Source data are not imputed.
