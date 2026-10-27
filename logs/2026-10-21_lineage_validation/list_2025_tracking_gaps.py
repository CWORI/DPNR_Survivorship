"""List actual Coki E lineage gaps for TagLab review.

Inputs: processed Matches rows and original-object tracking in outputs/Tables.
Outputs: original-level list and deduplicated TagLab review tasks in outputs/Tables.
Assumptions: a missing usable correspondence is unresolved, not a death.
Only originals unresolved at the final survey are included; raw data are read-only.
Run without arguments for 2025, or pass '2026' for April additions.
"""

import collections
import csv
import sys
from pathlib import Path

# Settings and file paths ----
cohort_year = sys.argv[1] if len(sys.argv) > 1 else "2025"
if cohort_year not in {"2025", "2026"}:
    raise ValueError("Cohort must be 2025 or 2026")
cohort_name = "2025 original outplants" if cohort_year == "2025" else "April 2026 additions"
original_id_field = "original_may_object_id" if cohort_year == "2025" else "original_april_object_id"
project_root = Path(__file__).resolve().parents[2]
table_dir = project_root / "outputs" / "Tables"
tracking_path = table_dir / "plot_e_object_lineage_tracking.csv"
matches_path = project_root / "data_processed" / "outplant_interval_rows.csv"

# 1. Index the real Matches correspondence rows and tracking histories ----
with matches_path.open() as stream:
    matches = [r for r in csv.DictReader(stream) if r["plot"] == "Plot E"]
connections = collections.defaultdict(list)
interval_files = collections.defaultdict(set)
for row in matches:
    interval_files[(row["plot_section"], row["month_start_date"], row["month_end_date"])].add(row["source_file"])
    if row["present_start"] == "TRUE":
        connections[(row["plot_section"], row["month_end_date"], row["blob_start"])].append(row)

histories = collections.defaultdict(list)
with tracking_path.open() as stream:
    for row in csv.DictReader(stream):
        if row["cohort"] == cohort_name:
            histories[row["original_individual_id"]].append(row)

# 2. Find every broken branch for originals unresolved at the final survey ----
original_rows = []
tasks = {}
for stable_id, history in histories.items():
    history.sort(key=lambda r: r["survey_date"])
    if history[-1]["tracking_status"] != "Unresolved tracking gap":
        continue
    gaps = []
    for previous, current in zip(history, history[1:]):
        for object_id in filter(None, previous["living_descendant_ids"].split(";")):
            edges = connections[(current["plot_section"], current["survey_date"], object_id)]
            if any(edge["present_end"] == "TRUE" for edge in edges):
                continue
            if edges and all(edge["action"] == "dead" for edge in edges):
                continue
            key = (current["plot_section"], previous["survey_date"], current["survey_date"], object_id)
            gaps.append(key)
            if key not in tasks:
                tasks[key] = {
                    "section": key[0], "last_connected_survey": key[1],
                    "first_missing_connection_survey": key[2], "source_object_id_to_find": key[3],
                    "matches_file_to_review": ";".join(sorted(interval_files[key[:3]])),
                    "gap_reason": "Source object absent from usable start rows" if not edges else "No live destination and not all rows explicitly dead",
                    "affected_original_ids": set(), "review_status": "Not reviewed",
                }
            tasks[key]["affected_original_ids"].add(history[0]["original_object_id"])
    assert gaps, stable_id
    first_gap = min(gaps, key=lambda k: k[2])
    first_flagged = next(r["survey_date"] for r in history if r["has_unresolved_branch"] == "TRUE")
    assert first_gap[2] == first_flagged, stable_id
    first_unresolved = next(r["survey_date"] for r in history if r["tracking_status"] == "Unresolved tracking gap")
    original_rows.append({
        "original_individual_id": stable_id, "section": history[0]["plot_section"],
        original_id_field: history[0]["original_object_id"],
        "last_connected_survey_before_first_gap": first_gap[1],
        "first_missing_connection_survey": first_gap[2],
        "source_object_ids_at_first_gap": ";".join(sorted({k[3] for k in gaps if k[2] == first_gap[2]}, key=int)),
        "first_survey_with_no_tracked_living_descendant": first_unresolved,
        "matches_file_at_first_gap": ";".join(sorted(interval_files[first_gap[:3]])),
        "review_status": "Not reviewed",
    })

# 3. Write auditable lists without changing the analysis or raw data ----
original_rows.sort(key=lambda r: (r["first_missing_connection_survey"], r["section"], int(r[original_id_field])))
task_rows = []
for key in sorted(tasks, key=lambda k: (k[2], k[0], int(k[3]))):
    row = tasks[key]
    original_ids = row["affected_original_ids"]
    row["n_affected_original_outplants"] = len(original_ids)
    row["affected_original_ids"] = ";".join(sorted(original_ids, key=int))
    task_rows.append(row)
for filename, rows, fieldnames in [
    (f"plot_e_{cohort_year}_unresolved_originals_review.csv", original_rows,
     ["original_individual_id", "section", original_id_field,
      "last_connected_survey_before_first_gap", "first_missing_connection_survey",
      "source_object_ids_at_first_gap", "first_survey_with_no_tracked_living_descendant",
      "matches_file_at_first_gap", "review_status"]),
    (f"plot_e_{cohort_year}_taglab_gap_review_tasks.csv", task_rows,
     ["section", "last_connected_survey", "first_missing_connection_survey",
      "source_object_id_to_find", "matches_file_to_review", "gap_reason",
      "affected_original_ids", "review_status", "n_affected_original_outplants"]),
]:
    with (table_dir / filename).open("w", newline="") as stream:
        # An empty list means no final unresolved originals, not a failed export.
        writer = csv.DictWriter(stream, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    print(f"{filename}: {len(rows)} rows")
print("First-gap survey counts:")
for date, count in sorted(collections.Counter(r["first_missing_connection_survey"] for r in original_rows).items()):
    print(date, count)
