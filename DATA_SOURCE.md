# Data source & provenance — DDESVSFS PNES/epilepsy screening tool (Janocko et al. 2021)

## Paper
Janocko NJ, Jing J, Fan Z, Teagarden DL, Villarreal HK, Morton ML, Groover O, Loring DW,
Drane DL, **Westover MB**, Karakis I. *DDESVSFS: A simple, rapid and comprehensive screening
tool for the Differential Diagnosis of Epileptic Seizures VS Functional Seizures.*
**Epilepsy Res 2021;171:106563.** doi:10.1016/j.eplepsyres.2021.106563 · PMID 33517166.

## Committed data (de-identified)
- **`pnespredictiondeidentified.xlsx`** — 208 patients × 24 variables: de-identified patient
  id (`ptid`), outcome (`es` = epileptic vs functional/psychogenic seizures), and
  questionnaire/clinical features (EEG/imaging normal, risk factors, demographics, seizure
  characteristics, AED count, compliance). **No names, MRNs, or dates** (PHI-scanned 2026-07-09: 0 hits).
- **`featureSelected.mat`** — the nested-CV LASSO-selected features + fitted logistic model.
- **`cali_plot.mat`** — calibration-curve data.
- `PNES_codebook.docx` — variable dictionary.

## Data origin
Emory University epilepsy/functional-seizure cohort (senior author I. Karakis, Emory);
analysis with MGH (Jing, Westover). Released de-identified for reproducibility.

## Lineage
Structured intake questionnaire + clinical variables -> de-identified feature table
(`pnespredictiondeidentified.xlsx`) -> nested-CV LASSO feature selection
(`step1_nestedCVlasso.m` -> `featureSelected.mat`) -> multivariable logistic regression,
ROC/calibration, and the integer DDESVSFS score (`main_*`).
