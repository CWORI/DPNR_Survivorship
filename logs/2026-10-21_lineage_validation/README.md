# Coki E lineage validation workbook

Output: `outputs/Tables/plot_e_lineage_validation.xlsx`.

This is a review workbook for the original-object lineage analysis. Its purpose
is to make the fusion/split counting rule and its source records inspectable.
It does not change the analysis or raw source files.

## What to inspect

1. Fusion example: original objects 131 and 136 in section 0-0 both connect to
   June object 128, and remain two original histories through September object 1.
   This example already shares exported Genet 3; it does not establish a known
   merger between distinct exported Genet IDs.
2. Split example: section 0-0 original object 201 has two living descendants in
   July 2026, while its original-individual contribution remains one.
3. Histories: all 1,898 original annotated objects, with one column per survey.
   Dates before the April cohort exists say Not yet enrolled. DEAD requires
   complete explicit death records. UNRESOLVED is not a recorded death.
4. Shared descendants: 1,566 section/survey/object cases retaining multiple
   original histories. These are shared-ancestry records, not independent fusion
   event counts.
5. Review gaps: 8 final unresolved original histories and the 9 May objects
   present only in the new Genet summaries. Review status and notes are editable;
   these entries do not automatically change source records or computed results.
6. Raw matches: all 13,191 exported correspondence rows with source file and CSV
   record number. CSV row 1 is the header.
7. Checks: independent raw-file traversal, cohort/date count agreement, source
   hashes, duplicate checks, and exact descendant/status comparisons across
   20,144 original/survey records. Snapshot diagnostics must be regenerated after
   source changes. Excel formulas summarize histories, not reconstruct the graph.

## Verification

The Python preparation independently traverses the configured raw Matches and
compares exact descendant sets, uncertainty flags, statuses and descendant counts
with every saved R tracking row. It separately aggregates cohort totals and checks
them against the saved R summary. All 64 raw Matches hashes match the original
intake manifest. The Excel summary is calculated from the visible history cells.
The builder checks input sensitivity and restores the original value before
export. The saved XLSX was independently read to verify formula caches, counts,
filters, eight sheets and no Excel error-valued cells. All sheets were rendered
for visual review. Native Microsoft Excel was not used to recalculate this file.

These checks establish computational agreement with the exports, not accuracy
of every match annotation, individual identity, or biological tissue survival
following fusion. Validate known distinct-Genet mergers against TagLab imagery.

## Rebuild

First regenerate the R lineage outputs by rendering the report. From the project
root, prepare an audited JSON payload and run the builder using the bundled
Codex Node runtime and artifact-tool package. Example shell commands:

```sh
mkdir -p /tmp/coki_e_workbook
python3 logs/2026-10-21_lineage_validation/prepare_validation.py /tmp/coki_e_workbook/data.json
# Create this link only if it does not already exist:
ln -s /Users/spencerparr/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules /tmp/coki_e_workbook/node_modules
cp logs/2026-10-21_lineage_validation/build_workbook.mjs /tmp/coki_e_workbook/build_workbook.mjs
/Users/spencerparr/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node /tmp/coki_e_workbook/build_workbook.mjs /tmp/coki_e_workbook/data.json "$PWD/outputs/Tables/plot_e_lineage_validation.xlsx" /tmp/coki_e_workbook/previews
```

The preparation also reads the four actual Genet summaries supplied at
`/Users/spencerparr/Downloads/OneDrive_1_10-20-2026/` to list the known source
discrepancy. No records are synthesized to fill missing correspondences.


### 2026-10-21: 2025 unresolved lineage review lists

Run `python3 logs/2026-10-21_lineage_validation/list_2025_tracking_gaps.py`
from the project root to generate `outputs/Tables/plot_e_2025_unresolved_originals_review.csv`
(71 final-unresolved originals) and `outputs/Tables/plot_e_2025_taglab_gap_review_tasks.csv`
(51 distinct section/survey-pair/source-object breaks). The task list uses the
last connected survey's object IDs, not May baseline IDs; it records affected
originals and the exact Matches filename. An original can contribute more than
one broken descendant, and multiple originals can share one broken descendant.
The first missing-branch date equals the first no-living-descendant date for
all 71 listed originals. These are export tracking gaps requiring image review,
not confirmed deaths or an explanation of the planting-log/baseline discrepancy.
No raw data or lineage statuses were changed.


### 2026-10-23: corrected Coki E Matches intake

Imported all 64 exports from `/Users/spencerparr/Downloads/OneDrive_1_10-23-2026/`;
32 files changed, with 13,171 raw correspondence rows. Source bytes are unchanged.
Five filename/date discrepancies were mapped to configured survey intervals
after the user confirmed those dates, including September 1 rather than
September 8 for the 0-1 final interval. Full source/destination names, hashes,
and dates are recorded in `logs/2026-10-27_plot_e_data_intake.csv`.
Previous inputs, cohort tables, processed Matches tables, validation workbook,
and all ten PDFs were preserved in
`archive/2026-10-23_coki_e_before_corrected_matches/`.

Current final-survey counts: 2025 baseline 796, living 393, recorded dead 378,
unresolved 25 (49.3719% lineage persistence). April baseline 1,103, living 924,
recorded dead 171, unresolved 8 (83.7715%). Of the previous 71 unresolved 2025
originals, 9 now have a living descendant, 37 have complete recorded deaths,
and 25 remain unresolved. The new May baseline includes section 0-0 object153.
April objects340 and341 in section0-0 now have incoming lineage connections
and therefore are not classified as new April additions. The October20 Genet
export comparison now has 9 May objects absent from the Matches baseline.

The report, ten Coki E vector PDFs, validation workbook, and remaining 2025
review lists were regenerated. The 25 unresolved originals correspond to18
distinct source-object gaps. Independent raw-file traversal agrees with all
20,150 saved R individual/date records and all23 cohort/date summaries. All64
current input hashes match intake; all17 cover-area partitions reconcile.
The workbook has no cached formula errors and passes the change/restore check.
These checks validate processing agreement, not the biological accuracy of
every annotation. No tracking gaps were filled or inferred. Nothing was pushed.


### 2026-10-27: final 2025 lineage corrections

Imported the 32 provided exports for sections 1-0 and 1-1 from
`/Users/spencerparr/Downloads/OneDrive_1_10-27-2026/`;10 files changed.
Sections 0-0 and 0-1 retain their October 23 inputs. The complete 64-file intake
manifest, source paths, filenames, hashes, interval dates and retention status
are in `logs/2026-10-27_plot_e_data_intake.csv`. Raw source bytes are preserved.
Incoming filenames have an extra space in section 1-0 and two use February 14
instead of the established February 16 survey date. The January-February file
is byte-identical to the prior February 16 export. Existing configured dates
were retained and those filename differences recorded rather than changing
the survey schedule. Previous data, tables, workbook and PDFs are preserved in
`archive/2026-10-27_coki_e_before_final_corrections/`.

All 25 previously unresolved 2025 originals now resolve:3 have a living
descendant and 22 have complete recorded-death connections. Final 2025 counts
are 796 baseline,396 living,400 recorded dead,0 unresolved,49.7487% lineage
persistence. No 2025 history retains an unresolved branch. April counts are
1,102 baseline,923 living,171 recorded dead,8 unresolved,83.7568% persistence.
April section 1-0 object 713 now has an incoming connection and is no longer
a new-April root. The remaining 8 April gaps span sections 0-0,0-1 and 1-0.
Their review locations are in `outputs/Tables/plot_e_2026_taglab_gap_review_tasks.csv`.
The 2025 review CSVs now contain headers only, reflecting zero unresolved cases.

Rerun review lists with
`python 3 logs/2026-10-21_lineage_validation/list_2025_tracking_gaps.py`
and append `2026` for the April cohort. Independent raw traversal agrees with
all 20,144 original/survey records and all 23 cohort/date summaries. All 64 input
hashes match intake, all 17 measured-cover partitions reconcile, and non-E
processed Matches rows are unchanged. The updated workbook passes its formula
change/restore check and has no cached formula errors. All ten Coki E PDFs
and the report were refreshed and visually checked. The original-versus-planting
inventory question remains separate. These changes have not been committed or pushed.
