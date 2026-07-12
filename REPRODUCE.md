# Reproduce — DDESVSFS PNES screening tool (Janocko et al., Epilepsy Res 2021)

MATLAB (R2016+, verified on R2026a) with the Statistics & Machine Learning Toolbox.

```matlab
main_ROC_and_Calibration     % ROC + calibration from featureSelected.mat -> AUC 0.929 [0.875-0.961]
main_ScoreSystem             % integer DDESVSFS point score
DDESVSFS_calculator          % apply the screening score to new inputs
main_TableMulti; main_TableUni   % multivariable / univariate odds-ratio tables
% step1_nestedCVlasso.m re-runs nested-CV LASSO feature selection from the xlsx (writes featureSelected.mat)
```

| Paper item | Script | Input (committed) | Output |
|---|---|---|---|
| ROC + AUC + calibration | `main_ROC_and_Calibration.m` | `featureSelected.mat`, `pnespredictiondeidentified.xlsx` | AUC 0.929 [0.875-0.961], cal err 0.061 |
| Integer DDESVSFS score | `main_ScoreSystem.m` | same | point score |
| Univariate / multivariable ORs | `main_TableUni.m` / `main_TableMulti.m` | same | tables |
| Feature selection (nested-CV LASSO) | `step1_nestedCVlasso.m` | `pnespredictiondeidentified.xlsx` | `featureSelected.mat` |

**Verified 2026-07-09:** `main_ROC_and_Calibration` reproduces AUC 0.929 (95% CI 0.875-0.961),
optimal operating point sensitivity 0.95 / specificity 0.70. See `DATA_SOURCE.md`.
