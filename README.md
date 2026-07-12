# DDESVSFS: screening tool for epileptic vs functional (psychogenic) seizures

MATLAB code and de-identified data for:

> Janocko NJ, Jing J, Fan Z, Teagarden DL, Villarreal HK, Morton ML, Groover O, Loring DW,
> Drane DL, **Westover MB**, Karakis I. *DDESVSFS: A simple, rapid and comprehensive screening
> tool for the Differential Diagnosis of Epileptic Seizures VS Functional Seizures.*
> **Epilepsy Res 2021;171:106563.** [doi:10.1016/j.eplepsyres.2021.106563](https://doi.org/10.1016/j.eplepsyres.2021.106563) · PMID 33517166

A multivariable logistic-regression screening tool (nested-CV LASSO feature selection) that
distinguishes epileptic from functional/psychogenic non-epileptic seizures from a rapid
structured questionnaire, in 208 patients (AUC 0.93).

## Reproduce

MATLAB R2016+ with the Statistics & ML Toolbox — see **[REPRODUCE.md](REPRODUCE.md)**:

```matlab
main_ROC_and_Calibration
```

## Data

`pnespredictiondeidentified.xlsx` — 208 × 24 de-identified questionnaire/clinical features
(`ptid`, no names/MRNs/dates). See **[DATA_SOURCE.md](DATA_SOURCE.md)**.

## License
BDSP credentialed data terms.
