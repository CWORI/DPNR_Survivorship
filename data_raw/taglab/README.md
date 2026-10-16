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
sections 1-0 and 1-1 stop in January 2026.

September 29, 2026: added nine user-supplied Plot F exports for sections 0-0,
0-1, and 1-0, spanning November 6, 2025 through August 20, 2026. Exact source
paths, row counts, and hashes are recorded in
`logs/2026-09-29_plot_f_data_intake.csv`. One 0-1 export contains two empty
trailing columns and ten comma-only rows; the raw source is preserved and the
generated QA table reports ten comma-only rows as missing values.

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

## October 16, 2026: Original Genet tracking audit

Checked all shared-survey blob IDs: no conflicting Genet assignments. No
original-cohort Genets reappear after absence. At the last survey, 137 of 412
original IDs are present, 227 have explicit dead records, and 48 are unresolved
absences. The report now distinguishes these statuses and exports per-ID and
per-survey tracking audits under outputs/Tables/plot_e_original_genet_tracking*.csv.
No unsupported ID remapping or imputed survival was applied. Added percentage
labels to every point in both E cohort figures.
