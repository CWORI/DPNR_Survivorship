# Data refresh validation

Observed 2026-09-23 06:42:37 -10 (Pacific/Tahiti).

- All 82 active CSV SHA-256 checksums match the supplied source bytes.
- Active CSV inventory exactly matches the intake manifest and 82 configured intervals; no duplicate plot/section/date interval keys.
- Raw inputs total 9,329 rows. No missing Genet/species fields or negative start/end areas. Optional tags are absent in all rows.
- Independent raw-file set intersections reproduce all 26 plot/date cumulative baseline and survivor counts.
- QA flags: five Plot E Genets with changing species labels; adjacent snapshots contain 63 missing Genets, 33 new Genets, eight species mismatches, and six area mismatches (counts across shared-month comparisons). Supplied values remain unchanged.
- Quarto rendered all three website pages successfully; project pre-push checks passed.
- Browser check confirmed updated homepage, populated Plot A and Plot H tabs, coverage and QA tables, and all 37 report images loaded with no broken images.
- Plot E full-plot cumulative results stop in January 2026; later partial-section coverage is explicitly documented.

These are run snapshots; rerun after changing inputs or analysis code.
