clc
close all
clear

T = readtable('..\pnespredictiondeidentified_JJ.xlsx'); 

hdrs = T.Properties.VariableNames';

y = cell2mat(table2cell(T(:,ismember(hdrs, 'es')==1)));% [1]Epilepsy [0]PNES %
N = length(y);             % 208 in total %
N1 = length(find(y==1));   % 165 %
N2 = length(find(y==0));   % 43  %

disp(['Epilapsy     [1]: ', num2str(N1), ' cases']);
disp(['PNES         [0]: ', num2str(N2), ' cases']); 

% 22 predictors to include %
candidatePredictors={'eegnormal';'imagingnormal';'rfes';'rfpnes';'allergies';'comorbidities';'substances';'pnessuggestive';'age';'gender';'income';'race';'insurance';'pteducation';'ptmaritalstatus';'ptemployment';'szfrequency';'injuries';'ageofonset';'duration';'noofaeds';'compliant'};       
lut = NaN(size(candidatePredictors, 1), 2);  
X = NaN(N, size(candidatePredictors, 1));
for i = 1:size(candidatePredictors, 1)
    var_i = candidatePredictors{i};
    idx = find(ismember(hdrs, var_i)==1);
    
    x = cell2mat(table2cell(T(:, idx)));
    n = length(find(isnan(x)&y~=2)); % #of unknown %
    lut(i, :) = [idx, n];
    
    x(isnan(x)) = nanmedian(x);
    X(:, i) = x;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested LASSO with CV for feature selection %
K = 10;

rng('default') % for reproducibility %
indices = crossvalind('Kfold', y, K);

idx = []; y_hat = []; 
idx_pred_in = cell(K, 1);

% Outer 10-fold CV for model performance evaluation %
for k = 1:K
    
    % a: split into 90% train and 10% test %
    disp(['- - Fold #', num2str(k)])
    test  = (indices == k); 
    train = ~test;

    Xtr = X(train, :); ytr = y(train, :);
    Xte = X(test,  :); yte = y(test,  :);
    
    % b. LASSO with 10-fold CV to select lambda %
    disp(['      - LASSO with ',num2str(K),'-fold CV on traning only'])
    rng('default') % for reproducibility %
    [B, FitInfo] = lassoglm(Xtr, ytr, 'binomial', 'NumLambda', 100, 'CV', K, 'MaxIter', 1e10);

    % c. lambda and so feature weights selected at 1SE away % 
    idxLambdaMinDeviance = FitInfo.Index1SE;
    idx_pred_in{k,1} = find(B(:,idxLambdaMinDeviance));
    
    disp(['      - select ', num2str(length(idx_pred_in{k,1})), ' predictors'])
    
    % d. predict on test data for model performance %
    B0 = FitInfo.Intercept(idxLambdaMinDeviance);
    coef = [B0; B(:,idxLambdaMinDeviance)];
    ypred = glmval(coef, Xte,'logit');

    % e. export test result for FigureS2 %
    idx = [idx; find(test==1)];
    y_hat = [y_hat;  ypred];
end
y_hat(idx) = y_hat; % align the idx with y %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Take union and export  %
[votes, idxPred] = hist(cell2mat(idx_pred_in), 1:size(X, 2));
predictors = candidatePredictors(idxPred(votes>0)); % put a threshold if necessary 0 means to take all %
X = X(:, idxPred(votes>0));

nVotes = votes(idxPred(votes>0))';
save('featureSelected.mat', 'predictors', 'X',  'y',  'y_hat', 'nVotes');





