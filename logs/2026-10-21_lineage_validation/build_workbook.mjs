// Build the Coki E validation workbook from prepare_validation.py's audited JSON.
// Uses the Codex bundled artifact-tool runtime. No analytical inputs are modified.
import fs from 'node:fs/promises';
import { Workbook, SpreadsheetFile } from '@oai/artifact-tool';

const data = JSON.parse(await fs.readFile(process.argv[2], 'utf8'));
const output = process.argv[3];
const previewDir = process.argv[4];
const wb = Workbook.create();
const names = ['Summary', 'Fusion example', 'Split example', 'Histories',
  'Shared descendants', 'Review gaps', 'Raw matches', 'Checks'];
const sheets = Object.fromEntries(names.map(name => [name, wb.worksheets.add(name)]));
const navy = '#18364A', amber = '#FFF0CF', light = '#EDF3F7';
const lastHistory = data.histories.length + 5;
const excelDate = text => new Date(`${text}T12:00:00Z`);
const col = n => { let result = ''; for (n++; n; n = Math.floor((n - 1) / 26)) result = String.fromCharCode(65 + (n - 1) % 26) + result; return result; };

function base(name, title, headers, rows, widths, note = '') {
  const s = sheets[name];
  s.showGridLines = false;
  s.getRange('A2').values = [[title]];
  s.getRange('A2').format.font = {name: 'Arial', size: 15, bold: true, color: navy};
  if (note) {
    s.getRange('A3').values = [[note]];
    s.getRange('A3').format.font = {name: 'Arial', size: 10, italic: true, color: '#52636F'};
  }
  const end = rows.length + 5;
  s.getRange(`A5:${col(headers.length - 1)}5`).values = [headers];
  if (rows.length) s.getRange(`A6:${col(headers.length - 1)}${end}`).values = rows;
  s.getRange(`A5:${col(headers.length - 1)}${end}`).format.font = {name: 'Arial', size: 10, color: '#20323D'};
  s.getRange(`A5:${col(headers.length - 1)}${end}`).format.rowHeight = 23;
  s.getRange(`A5:${col(headers.length - 1)}5`).format = {
    fill: navy, font: {name: 'Arial', size: 10, bold: true, color: '#FFFFFF'},
    wrapText: true, rowHeight: 39, horizontalAlignment: 'center', verticalAlignment: 'center'
  };
  widths.forEach((width, i) => s.getRange(`${col(i)}5:${col(i)}${end}`).format.columnWidth = width);
  if (rows.length > 20) {
    s.freezePanes.freezeRows(5);
    s.freezePanes.freezeColumns(1);
  }
  if (rows.length) s.tables.add(`A5:${col(headers.length - 1)}${end}`, true, name.replaceAll(' ', '') + 'Table');
  return s;
}

// One permanent original per row, with every survey's descendant set retained.
const historyRows = data.histories.map(row => row.map((value, i) => i === 4 ? excelDate(value) : value));
const hist = base('Histories', 'Original-object histories',
  ['Permanent original ID', 'Outplant session', 'Section', 'Original object ID', 'Baseline date', 'Exported baseline Genet',
    ...data.dates.map(d => excelDate(d))], historyRows,
  [34, 27, 10, 13, 15, 17, ...data.dates.map(() => 23)],
  'One row per original. Objects: lists living descendants. DEAD requires complete explicit death records. UNRESOLVED is not death.');
hist.getRange(`E6:E${lastHistory}`).setNumberFormat('dd mmm yyyy');
hist.getRange('G5:W5').setNumberFormat('dd mmm yyyy');
hist.getRange(`G6:W${lastHistory}`).format.wrapText=true;
data.histories.forEach((row,i)=>{
  if(row.slice(6).some(value=>value.length>24))hist.getRange(`A${i+6}:W${i+6}`).format.rowHeight=39;
});
hist.getRange(`G6:W${lastHistory}`).conditionalFormats.add('containsText', {text:'UNRESOLVED',format:{fill:amber,font:{color:'#7D5200'}}});
hist.getRange(`G6:W${lastHistory}`).conditionalFormats.add('containsText', {text:'DEAD',format:{fill:'#FBE9E6',font:{color:'#9B3029'}}});

// Summary formulas calculate from the history cells, not copied chart results.
const summary = base('Summary', 'Coki E lineage validation',
  ['Outplant session', 'Survey date', 'Original objects', 'Living descendant', 'Recorded dead', 'Unresolved', 'Lineage persistence', 'Roster difference'],
  [[null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null]],
  [29, 16, 16, 18, 17, 16, 20, 18]);
summary.tabColor = navy;
summary.getRange('A9').values = [['Every original remains on the roster: living + recorded dead + unresolved = original count.']];
summary.getRange('A10').values = [['Lineage persistence means a documented living descendant, including shared fused descendants. It does not prove individual tissue survival.']];
summary.getRange('A9:H10').format.font = {name:'Arial',size:10,color:'#52636F'};
const monthly = data.summary;
summary.getRange('A12:H12').values = [['Outplant session','Survey date','Original objects','Living descendant','Recorded dead','Unresolved','Lineage persistence','Roster difference']];
summary.getRange('A12:H12').format = {fill:navy,font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},wrapText:true,rowHeight:39};
for (let i=0;i<monthly.length;i++) {
  const row = i + 13, x=monthly[i], dateCol=col(6 + data.dates.indexOf(x.survey_date));
  summary.getRange(`A${row}:B${row}`).values = [[x.cohort, excelDate(x.survey_date)]];
  summary.getRange(`C${row}:H${row}`).formulas = [[
    `=COUNTIFS('Histories'!$B$6:$B$${lastHistory},A${row})`,
    `=COUNTIFS('Histories'!$B$6:$B$${lastHistory},A${row},'Histories'!$${dateCol}$6:$${dateCol}$${lastHistory},"<>DEAD",'Histories'!$${dateCol}$6:$${dateCol}$${lastHistory},"<>UNRESOLVED",'Histories'!$${dateCol}$6:$${dateCol}$${lastHistory},"<>Not yet enrolled")`,
    `=COUNTIFS('Histories'!$B$6:$B$${lastHistory},A${row},'Histories'!$${dateCol}$6:$${dateCol}$${lastHistory},"DEAD")`,
    `=COUNTIFS('Histories'!$B$6:$B$${lastHistory},A${row},'Histories'!$${dateCol}$6:$${dateCol}$${lastHistory},"UNRESOLVED")`,
    `=D${row}/C${row}`, `=C${row}-SUM(D${row}:F${row})`
  ]];
}
for (const [i, cohort] of ['2025 original outplants','April 2026 additions'].entries()) {
  const idx=monthly.findIndex(x => x.cohort===cohort && x.survey_date==='2026-09-01');
  summary.getRange(`A${i+6}:H${i+6}`).formulas = [[...Array(8)].map((_,j)=>`=${col(j)}${idx+13}`)];
}
summary.getRange('B6:B35').setNumberFormat('dd mmm yyyy');
summary.getRange('G6:G35').setNumberFormat('0.0%');
summary.getRange('A13:H35').format.font={name:'Arial',size:10};
summary.getRange('A13:H35').format.rowHeight=23;
summary.getRange('H13:H35').conditionalFormats.add('cellIs',{operator:'notEqual',formula:0,format:{fill:'#FBE9E6'}});
summary.getRange('A38').values=[[`${data.discrepancies.length} additional May objects in the October 20 Genet exports are absent from the current initial Matches. See Review gaps.`]];
summary.getRange('A39').values=[[`Snapshot: ${data.snapshot_date}. Editing history cells updates summary formulas; reconstructing the lineage graph requires rerunning the analysis.`]];
summary.getRange('A38:H39').format.font={name:'Arial',size:10,color:'#7D5200'};

const fusion=base('Fusion example','Two originals remain two histories after fusion',
  ['Survey date','Original 131 descendants','Original 136 descendants','131 retained','136 retained','Originals retained','Distinct current objects'],
  data.fusion.map(row=>[excelDate(row[0]),...row.slice(1)]),[17,27,27,16,16,19,23],
  'Section 0-0. The two objects already share exported Genet 3. This validates object fusion, not a separate-Genet merger.');
fusion.getRange('A6:A22').setNumberFormat('dd mmm yyyy');
for(let row=6;row<=22;row++) fusion.getRange(`D${row}:F${row}`).formulas=[[
  `=IF(LEFT(B${row},8)="Objects:",1,0)`, `=IF(LEFT(C${row},8)="Objects:",1,0)`, `=SUM(D${row}:E${row})`
]];
fusion.getRange('A25').values=[['May objects 131 and 136 both connect to June object 128. Each follows the shared lineage to September 2026 object 1.']];
fusion.getRange('A26').values=[['Source: 0-0_PlotE_Matches_20250507_20250609.csv']];
fusion.getRange('A27:E27').values=[['CSV row','Source object','Destination object','Action','Split/fuse']];
const fRows=data.raw.filter(x=>x[2]==='0-0'&&x[3]==='2025-05-07'&&['131','136'].includes(x[6])&&x[7]==='128');
fusion.getRange('A28:E29').values=fRows.map(x=>[x[1],x[6],x[7],x[11],x[12]]);
fusion.getRange('A32').values=[['To demonstrate a merger of distinct exported Genet IDs, select a known TagLab case and verify all incoming source-to-destination links.']];

const split=base('Split example','One original remains one count after splitting',
  ['Survey date','Original 201 descendants','Living descendant count','Originals retained'],
  data.split.map(row=>[excelDate(row[0]),...row.slice(1)]),[17,32,24,22],
  'Section 0-0, original object 201. In July 2026 the original has two living descendants but still counts once.');
split.getRange('A6:A22').setNumberFormat('dd mmm yyyy');
for(let row=6;row<=22;row++) split.getRange(`D${row}`).formulas=[[`=IF(C${row}>0,1,0)`]];
split.getRange('A25').values=[['Splitting increases descendant objects, never the initial-individual denominator.']];

const shared=base('Shared descendants','Originals sharing the same living descendant',
  ['Section','Survey date','Shared object ID','Original histories retained','Permanent original IDs'],
  data.shared.map(x=>[x[0],excelDate(x[1]),...x.slice(2)]),[11,17,18,24,125],
  'One row per section/survey/object shared by multiple originals. Ancestry may be shared after fusion and subsequent splitting.');
shared.getRange(`B6:B${data.shared.length+5}`).setNumberFormat('dd mmm yyyy');
shared.getRange(`E6:E${data.shared.length+5}`).format.wrapText=true;
data.shared.forEach((row,i)=>{
  if(row[4].length>145)shared.getRange(`A${i+6}:E${i+6}`).format.rowHeight=42;
});

const gaps=base('Review gaps','Histories requiring TagLab review',
  ['Permanent original ID','Outplant session','Section','Original object ID','Baseline date','Last living survey','First unresolved branch','Reason','Review status','Reviewer notes'],
  data.issues.map(x=>x.map((v,i)=>[4,5,6].includes(i)?excelDate(v):v)),
  [34,27,10,14,16,17,21,43,28,65],
  `${data.issues.length} originals end unresolved: ${data.issues.filter(x=>x[1]==='2025 original outplants').length} from 2025 and ${data.issues.filter(x=>x[1]==='April 2026 additions').length} from April. A blank reviewer note means no review has been recorded.`);
gaps.getRange('E6:G84').setNumberFormat('dd mmm yyyy');
gaps.getRange('I6:J84').format.fill=amber;
gaps.getRange('I6:I84').dataValidation={rule:{type:'list',values:['Not reviewed','Missing match confirmed','Death confirmed in imagery','Other finding']}};
gaps.getRange('A87').values=[['Additional May objects in Genet export, absent from baseline Matches (excluded until reconciled)']];
gaps.getRange('A89:H89').values=[['Section','Object ID','Exported Genet','Exported area','Genet source file','Discrepancy','Review status','Reviewer notes']];
gaps.getRange('A89:H89').format={fill:navy,font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},wrapText:true,rowHeight:39};
if(data.discrepancies.length) gaps.getRange(`A90:H${89+data.discrepancies.length}`).values=data.discrepancies;
gaps.getRange('E89:F99').format.wrapText=true;
gaps.getRange('A90:H99').format.rowHeight=57;
gaps.getRange('G90:H99').format.fill=amber;
gaps.getRange('A102').values=[['Reviewer entries are audit notes. They do not change source data or automatically repair the tracking graph.']];

const raw=base('Raw matches','Raw Coki E correspondence records',
  ['Source file','CSV row','Section','Start survey','End survey','Exported Genet','Source object','Destination object','Source area','Destination area','Class','Action','Split/fuse','Area units'],
  data.raw.map(x=>x.map((v,i)=>[3,4].includes(i)?excelDate(v):v)),
  [61,10,10,16,16,17,17,20,17,19,31,14,15,12],
  'Source: data_raw/taglab/Plot_E/*.csv, listed in config/outplant_interval_files/Plot_E.csv. Areas retain original export values.');
raw.getRange(`D6:E${data.raw.length+5}`).setNumberFormat('dd mmm yyyy');
raw.getRange(`I6:J${data.raw.length+5}`).setNumberFormat('0.0000');

const checks=base('Checks','Independent validation and source integrity',
  ['Check','Expected','Observed','Result'], data.checks.map(x=>[...x,null]),[86,17,17,20],
  `Diagnostics compare R outputs with a separate Python traversal of all ${data.checked_records.toLocaleString('en-US')} original/survey records. Snapshot: ${data.snapshot_date}.`);
for(let row=6;row<6+data.checks.length;row++)checks.getRange(`D${row}`).formulas=[[`=IF(B${row}=C${row},"PASS","FAIL")`]];
checks.getRange('A14').values=[['Cohort/date agreement with independently reconstructed raw Matches counts']];
checks.getRange('A16:H16').values=[['Outplant session','Survey date','Independent living','Workbook living','Independent dead','Workbook dead','Independent unresolved','Workbook unresolved']];
data.independent_summary.forEach((x,i)=>{
  const row=i+17;
  checks.getRange(`A${row}:H${row}`).values=[[x.cohort,excelDate(x.survey_date),Number(x.n_surviving),null,Number(x.n_recorded_dead),null,Number(x.n_unresolved),null]];
  checks.getRange(`D${row}`).formulas=[[`='Summary'!D${i+13}`]];
  checks.getRange(`F${row}`).formulas=[[`='Summary'!E${i+13}`]];
  checks.getRange(`H${row}`).formulas=[[`='Summary'!F${i+13}`]];
});
checks.getRange('B17:B39').setNumberFormat('dd mmm yyyy');
checks.getRange('I16').values=[['Count difference']];
checks.getRange('I16:I39').format.columnWidth=20;
for(let row=17;row<=39;row++)checks.getRange(`I${row}`).formulas=[[`=ABS(C${row}-D${row})+ABS(E${row}-F${row})+ABS(G${row}-H${row})`]];
checks.getRange('A42').values=[[`Source file SHA-256 checks against ${data.intake_manifest}`]];
checks.getRange('A44:E44').values=[['Source file','Source rows','Intake SHA-256','Current SHA-256','Hash matches']];
checks.getRange('A45:E108').values=data.manifest;
checks.getRange('A5:A113').format.columnWidth=70;
checks.getRange('C5:E108').format.columnWidth=24;
checks.getRange('F16:F39').format.columnWidth=18;
checks.getRange('G16:H39').format.columnWidth=24;
checks.getRange('A6:A11').format.wrapText=true;
checks.getRange('A6:D11').format.rowHeight=40;
checks.getRange('C45:D108').format.wrapText=true;
checks.getRange('A45:E108').format.rowHeight=60;
checks.getRange('A16:I16').format={fill:navy,font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},wrapText:true,rowHeight:40};
checks.getRange('A111').values=[[`Remaining validation: confirm distinct-Genet fusion examples, review unresolved links, reconcile the ${data.discrepancies.length} additional baseline objects, and confirm baseline objects represent individual outplants.`]];
checks.getRange('A113').values=[['Method: lineage status is reconstructed outside Excel. The workbook formulas summarize visible histories; editing raw rows does not rebuild correspondences. Rerun the supplied analysis and workbook builders after source changes.']];

for (const s of Object.values(sheets)) {
  s.getRange('A1').format.rowHeight=9;
  s.getRange('A3').format.rowHeight=26;
}
wb.recalculate();
// Inspect only bounded result ranges; every formula must be free of errors.
console.log((await wb.inspect({kind:'table',range:'Summary!A5:H7',include:'values,formulas',tableMaxRows:3,tableMaxCols:8,maxChars:2200})).ndjson);
console.log((await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A|#NUM!|#NULL!|#SPILL!|#CALC!',options:{useRegex:true,maxResults:30},summary:'formula errors',maxChars:1500})).ndjson);
// Test actual formula sensitivity and restore before saving.
const before=summary.getRange('D29').values[0][0];
const historyIndex=data.histories.findIndex(x=>x[0]==='0-0__2025-05-07__131')+6;
const cell=hist.getRange(`W${historyIndex}`),saved=cell.values;
cell.values=[['UNRESOLVED']];wb.recalculate();
if(summary.getRange('D29').values[0][0]!==before-1)throw new Error('History-to-summary sensitivity failed');
cell.values=saved;wb.recalculate();
if(summary.getRange('D29').values[0][0]!==before)throw new Error('Restore failed');
await fs.mkdir(previewDir,{recursive:true});
for(const name of names){
  const range=name==='Summary'?'A1:H10':name==='Fusion example'?'A1:G12':name==='Split example'?'A1:D12':name==='Histories'?'A1:J10':name==='Shared descendants'?'A1:E11':name==='Review gaps'?'A1:H10':name==='Raw matches'?'A1:H10':'A1:D12';
  const preview=await wb.render({sheetName:name,range,scale:1.25,format:'png'});
  await fs.writeFile(`${previewDir}/${name.replaceAll(' ','_')}.png`,new Uint8Array(await preview.arrayBuffer()));
}
for(const [name,range,label] of [['Fusion example','A18:G32','Fusion_final'],['Split example','A17:D22','Split_event'],['Review gaps','A87:H99','Extra_baseline_objects']]){
  const preview=await wb.render({sheetName:name,range,scale:1.25,format:'png'});
  await fs.writeFile(`${previewDir}/${label}.png`,new Uint8Array(await preview.arrayBuffer()));
}
const file=await SpreadsheetFile.exportXlsx(wb);
await file.save(output);
console.log(`Saved ${output}`);
