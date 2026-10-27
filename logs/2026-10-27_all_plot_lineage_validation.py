"""Independently verify A-H lineage histories against configured raw Matches.

Inputs: config/outplant_interval_files, raw CSV exports, stage 06 outputs.
Output: logs/2026-10-27_all_plot_lineage_validation.txt.
Only real input records are used. Missing links are unknown, not inferred deaths.
"""
import collections
import csv
import json
from pathlib import Path

def positive(value: str) -> bool:
    # Missing area is not a measured zero and cannot establish positive presence.
    return value.strip() not in {"", "NA", "NaN"} and float(value) > 0

root = Path(__file__).resolve().parents[1]
tables = root / "outputs/Tables"
raw_intervals = collections.defaultdict(list)
file_count = 0
for config_path in sorted((root / "config/outplant_interval_files").glob("Plot_?.csv")):
    for item in csv.DictReader(config_path.open()):
        path = root / "data_raw/taglab" / item["plot_folder"] / item["file"]
        rows = list(csv.DictReader(path.open(encoding="utf-8-sig")))
        raw_intervals[(item["plot"], item["plot_section"])].append(
            (item["month_start_date"], item["month_end_date"], rows))
        file_count += 1

reference = {}
interval_reference = {}
for (plot, section), intervals in raw_intervals.items():
    intervals.sort()
    dates = [a for a, b, rr in intervals for r in rr if positive(r["Area1"])]
    dates += [b for a, b, rr in intervals for r in rr if positive(r["Area2"])]
    if not dates:
        continue
    baselines = ["2025-05-07", "2026-04-09"] if plot == "Plot E" else [min(dates)]
    for baseline_index, baseline in enumerate(baselines):
        if baseline_index == 0 and any(a == baseline for a, b, rr in intervals):
            roots = {r["Blob1"] for a, b, rr in intervals if a == baseline
                     for r in rr if positive(r["Area1"])}
        else:
            rr = next(rr for a, b, rr in intervals if b == baseline)
            roots = {r["Blob2"] for r in rr if positive(r["Area2"])}
            if baseline_index > 0:
                roots -= {r["Blob2"] for r in rr if positive(r["Area1"]) and positive(r["Area2"])}
        for original in roots:
            stable = f"{section}__{baseline}__{original}"
            descendants, unknown = {original}, False
            reference[(plot, stable, baseline)] = (descendants.copy(), unknown, "Living descendant observed")
            previous = baseline
            for start, end, rr in intervals:
                if start < baseline:
                    continue
                next_descendants = set()
                for obj in descendants:
                    edges = [r for r in rr if start == previous and r["Blob1"] == obj and positive(r["Area1"])]
                    live = {r["Blob2"] for r in edges if positive(r["Area2"])}
                    if live:
                        next_descendants.update(live)
                    elif not edges or any(r["Action"].strip().lower() != "dead" for r in edges):
                        unknown = True
                descendants = next_descendants
                status = ("Living descendant observed" if descendants else
                          "Unresolved tracking gap" if unknown else "All tracked descendants recorded dead")
                reference[(plot, stable, end)] = (descendants.copy(), unknown, status)
                previous = end
    for start, end, rr in intervals:
        sources = {r["Blob1"] for r in rr if positive(r["Area1"])}
        for obj in sources:
            edges = [r for r in rr if r["Blob1"] == obj and positive(r["Area1"])]
            live = {r["Blob2"] for r in edges if positive(r["Area2"])}
            status = ("Living descendant observed" if live else
                      "All tracked descendants recorded dead" if all(r["Action"].strip().lower() == "dead" for r in edges)
                      else "Unresolved tracking gap")
            interval_reference[(plot, section, start, end, obj)] = (live, status)

tracking = list(csv.DictReader((tables / "outplant_object_lineage_tracking.csv").open()))
assert len(reference) == len(tracking)
for row in tracking:
    key = (row["plot"], row["original_individual_id"], row["survey_date"])
    observed = (set(filter(None, row["living_descendant_ids"].split(";"))),
                row["has_unresolved_branch"] == "TRUE", row["tracking_status"])
    assert observed == reference[key], (key, observed, reference[key])
interval_tracking = list(csv.DictReader((tables / "outplant_object_interval_tracking.csv").open()))
assert len(interval_reference) == len(interval_tracking)
for row in interval_tracking:
    key = (row["plot"], row["plot_section"], row["month_start_date"], row["month_end_date"], row["source_object_id"])
    assert (set(filter(None, row["living_descendant_ids"].split(";"))), row["tracking_status"]) == interval_reference[key], key

latest = {}
for row in csv.DictReader((tables / "outplant_cumulative_survival_summary.csv").open()):
    assert int(row["n_baseline"]) == sum(int(row[k]) for k in ["n_surviving_from_baseline", "cumulative_deaths_observed", "n_unresolved"])
    if row["plot"] not in latest or row["survey_date"] > latest[row["plot"]]["survey_date"]:
        latest[row["plot"]] = row
result = {"raw_files": file_count, "original_survey_records_checked": len(reference),
          "source_object_intervals_checked": len(interval_reference), "mismatches": 0,
          "latest_complete_surveys": latest}
(root / "logs/2026-10-27_all_plot_lineage_validation.txt").write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps({k: v for k, v in result.items() if k != "latest_complete_surveys"}))
