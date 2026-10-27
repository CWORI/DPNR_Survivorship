"""Build an independent, raw-Matches audit payload for the Coki E workbook.

Inputs: configured Plot E raw Matches, object-lineage outputs, Genet exports.
Output: JSON at the command-line path. Does not alter analysis inputs/outputs.
Assumptions: annotated baseline objects are the counted individuals; no inferred
connections. A living fused descendant establishes documented ancestry only.
"""
from pathlib import Path
import collections
import csv
import hashlib
import json
import re
import sys
from datetime import date

project = Path(__file__).resolve().parents[2]
genet_source = Path('/Users/spencerparr/Downloads/OneDrive_1_10-20-2026')
output = Path(sys.argv[1])
intake_path = Path(sys.argv[2]) if len(sys.argv) > 2 else max((project / 'logs').glob('*_plot_e_data_intake.csv'))
snapshot_date = date.fromisoformat(intake_path.name[:10]).strftime('%d %B %Y')

def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline='', encoding='utf-8-sig') as stream:
        return list(csv.DictReader(stream))

# 1. Read unchanged raw rows, retaining file and row provenance.
config = read_csv(project / 'config/outplant_interval_files/Plot_E.csv')
raw = []
intervals = collections.defaultdict(list)
baseline_genets = collections.defaultdict(set)
manifest = []
intake = {Path(x['destination_path']).name: x['sha256'] for x in
          read_csv(intake_path)}
for item in config:
    path = project / 'data_raw/taglab/Plot_E' / item['file']
    rows = read_csv(path)
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    manifest.append([item['file'], len(rows), intake[item['file']], digest,
                     digest == intake[item['file']]])
    for csv_row, row in enumerate(rows, 2):
        sec, start, end = item['plot_section'], item['month_start_date'], item['month_end_date']
        intervals[(sec, start, end)].append(row)
        raw.append([item['file'], csv_row, sec, start, end, row['Genet'],
                    row['Blob1'], row['Blob2'], float(row['Area1']),
                    float(row['Area2']), row['Class'], row['Action'],
                    row['Split\\Fuse'], item['taglab_area_units']])
        if start == '2025-05-07' and float(row['Area1']) > 0:
            baseline_genets[(sec, start, row['Blob1'])].add(row['Genet'])
        if end == '2026-04-09' and float(row['Area2']) > 0:
            baseline_genets[(sec, end, row['Blob2'])].add(row['Genet'])

# 2. Independently follow original objects using only the raw correspondence rows.
reference = {}
for sec in sorted({x['plot_section'] for x in config}):
    chain = sorted((a, b, rr) for (s, a, b), rr in intervals.items() if s == sec)
    for start in ['2025-05-07', '2026-04-09']:
        if start == '2025-05-07':
            roots = {x['Blob1'] for a, b, rr in chain if a == start
                     for x in rr if float(x['Area1']) > 0}
        else:
            rr = next(rr for a, b, rr in chain if b == start)
            incoming = {x['Blob2'] for x in rr if float(x['Area1']) > 0 and float(x['Area2']) > 0}
            roots = {x['Blob2'] for x in rr if float(x['Area2']) > 0} - incoming
        for root in roots:
            nodes, uncertain = {root}, False
            stable = f'{sec}__{start}__{root}'
            reference[(stable, start)] = (set(nodes), uncertain, 'Living descendant observed')
            for a, b, rr in chain:
                if a < start:
                    continue
                destinations = set()
                for node in nodes:
                    rows = [x for x in rr if x['Blob1'] == node and float(x['Area1']) > 0]
                    live = {x['Blob2'] for x in rows if float(x['Area2']) > 0}
                    if live:
                        destinations.update(live)
                    elif not rows or any(x['Action'].lower() != 'dead' for x in rows):
                        uncertain = True
                nodes = destinations
                status = ('Living descendant observed' if nodes else
                          'Unresolved tracking gap' if uncertain else
                          'All tracked descendants recorded dead')
                reference[(stable, b)] = (set(nodes), uncertain, status)

# 3. Compare every individual/date, not only cohort percentages.
tracking = read_csv(project / 'outputs/Tables/plot_e_object_lineage_tracking.csv')
summary = read_csv(project / 'outputs/Tables/plot_e_object_lineage_survival.csv')
reference_totals = collections.defaultdict(lambda: [0, 0, 0, 0])
for (stable, date), (nodes, uncertain, status) in reference.items():
    baseline = stable.split('__')[1]
    totals = reference_totals[(baseline, date)]
    totals[0] += 1
    totals[1] += bool(nodes)
    totals[2] += not nodes and not uncertain
    totals[3] += not nodes and uncertain
independent_summary = []
for row in summary:
    counts = reference_totals[(row['first_present'], row['survey_date'])]
    observed = [int(row[k]) for k in ['n_baseline', 'n_surviving', 'n_recorded_dead', 'n_unresolved']]
    assert observed == counts, (row, counts)
    independent_summary.append(dict(cohort=row['cohort'], survey_date=row['survey_date'],
                                     n_baseline=counts[0], n_surviving=counts[1],
                                     n_recorded_dead=counts[2], n_unresolved=counts[3]))
by_id = collections.defaultdict(dict)
mismatches = []
for row in tracking:
    key = (row['original_individual_id'], row['survey_date'])
    actual = (set(filter(None, row['living_descendant_ids'].split(';'))),
              row['has_unresolved_branch'] == 'TRUE', row['tracking_status'])
    assert int(row['n_living_descendants']) == len(actual[0]), key
    if reference.get(key) != actual:
        mismatches.append(key)
    by_id[key[0]][key[1]] = row
assert len(reference) == len(tracking)
assert not mismatches, mismatches[:5]
dates = sorted({x['survey_date'] for x in tracking})
histories, issues = [], []
status_text = {'All tracked descendants recorded dead': 'DEAD',
               'Unresolved tracking gap': 'UNRESOLVED'}
for stable, history in sorted(by_id.items()):
    first = history[min(history)]
    cell_values = []
    for date in dates:
        row = history.get(date)
        cell_values.append('Not yet enrolled' if row is None else
                           status_text.get(row['tracking_status'], 'Objects: ' + row['living_descendant_ids']))
    source_genets = ';'.join(sorted(baseline_genets[(first['plot_section'], first['first_present'], first['original_object_id'])]))
    histories.append([stable, first['cohort'], first['plot_section'], first['original_object_id'],
                      first['first_present'], source_genets] + cell_values)
    last = history[max(history)]
    if last['tracking_status'] == 'Unresolved tracking gap':
        last_alive = max(d for d, x in history.items() if int(x['n_living_descendants']) > 0)
        first_unknown = min(d for d, x in history.items() if x['has_unresolved_branch'] == 'TRUE')
        issues.append([stable, first['cohort'], first['plot_section'], first['original_object_id'],
                       first['first_present'], last_alive, first_unknown,
                       'No complete descendant connection', 'Not reviewed', None])

# 4. List all shared descendant objects and the distinct originals they retain.
shared = collections.defaultdict(set)
for row in tracking:
    for obj in filter(None, row['living_descendant_ids'].split(';')):
        shared[(row['plot_section'], row['survey_date'], obj)].add(row['original_individual_id'])
shared_rows = [[sec, date, obj, len(originals), '; '.join(sorted(originals))]
               for (sec, date, obj), originals in sorted(shared.items()) if len(originals) > 1]

# 5. Real, traceable fusion and split examples. No manufactured test data.
fusion = []
for date in dates:
    entries = [by_id[f'0-0__2025-05-07__{obj}'][date] for obj in ['131', '136']]
    cells = [status_text.get(x['tracking_status'], 'Objects: ' + x['living_descendant_ids']) for x in entries]
    unique = set().union(*(set(filter(None, x['living_descendant_ids'].split(';'))) for x in entries))
    fusion.append([date, *cells, None, None, None, len(unique)])
assert by_id['0-0__2025-05-07__131']['2026-09-01']['living_descendant_ids'] == '1'
assert by_id['0-0__2025-05-07__136']['2026-09-01']['living_descendant_ids'] == '1'
split = []
for date, x in sorted(by_id['0-0__2025-05-07__201'].items()):
    split.append([date, status_text.get(x['tracking_status'], 'Objects: ' + x['living_descendant_ids']),
                  int(x['n_living_descendants']), None])

# 6. Preserve the known source discrepancy, with exact source references.
source_discrepancies = []
for path in sorted(genet_source.glob('*.csv')):
    sec = path.name[:3]
    for row in read_csv(path):
        if not row.get('genet', '').strip():
            continue
        col = next(k for k in row if '20250507' in k and k.endswith(' Object id'))
        ids, areas = row[col].split(), row[col.replace('Object id', 'Area')].split()
        for i, obj in enumerate(ids):
            if (sec, '2025-05-07', obj) not in baseline_genets:
                source_discrepancies.append([sec, obj, row['genet'], float(areas[i]), path.name,
                                             'Absent from initial Matches', 'Not reviewed', None])

checks = [
    ['Individual/date descendant sets and statuses disagree with raw-file traversal', 0, len(mismatches)],
    ['Missing individual/date records versus independent traversal', 0, len(reference) - len(tracking)],
    ['Duplicate original/date records', 0, len(tracking) - len({(x['original_individual_id'], x['survey_date']) for x in tracking})],
    ['Raw files differing from intake SHA-256 hashes', 0, sum(not x[4] for x in manifest)],
    ['Originals counted as living with no positive-area descendant', 0,
     sum(x['tracking_status'] == 'Living descendant observed' and int(x['n_living_descendants']) == 0 for x in tracking)],
    ['Recorded deaths with an unresolved branch', 0,
     sum(x['tracking_status'] == 'All tracked descendants recorded dead' and x['has_unresolved_branch'] == 'TRUE' for x in tracking)],
]
payload = dict(dates=dates, histories=histories, fusion=fusion, split=split,
               shared=shared_rows, issues=issues, discrepancies=source_discrepancies,
               raw=raw, manifest=manifest, checks=checks, summary=summary,
               independent_summary=independent_summary,
               checked_records=len(reference), snapshot_date=snapshot_date,
               intake_manifest=intake_path.name)
output.write_text(json.dumps(payload))
print(json.dumps({k: len(v) for k, v in payload.items() if isinstance(v, list)}))
