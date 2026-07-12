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

idx_pos = find(y==1);
idx_neg = find(y==0);

idx_con = [5 6 9 11 17 19 20];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uni-var L Regression %
for i = 1:size(X, 2)
    x = X(:, i);
    
    % mean(std) or % %
    if ~isempty(find(idx_con==i, 1))
        Stats(i, :) = {[mean(x(idx_pos)) std(x(idx_pos))] [mean(x(idx_neg)) std(x(idx_neg))]};
    else
        x_pos = x(idx_pos);
        x_neg = x(idx_neg);
        Stats(i, :) = {[sum(x_pos), length(x_pos), round(100*sum(x_pos)/length(x_pos))] [sum(x_neg), length(x_neg), round(100*sum(x_neg)/length(x_neg))]};
 
    end
    [b1, ~, stats1] = glmfit(x,  y, 'binomial', 'link', 'logit');
    
    B1(i, 1) = b1(2);
    P1(i, 1) = stats1.p(2);
    
    OR1(i, 1) = exp(b1(2));                     % odds_ratio(x_i) = exp(b_i) %
    CI1(i, 1) = exp(b1(2) - 1.96*stats1.se(2)); % odds_ratio_CI_lower(x_i) = exp(b_i-1.96*se_i) %
    CI1(i, 2) = exp(b1(2) + 1.96*stats1.se(2)); % odds_ratio_CI_upper(x_i) = exp(b_i+1.96*se_i) %
end
B1 = round(1E3*B1)/1E3;
OR1 = round(1E3*OR1)/1E3;
CI1 = round(1E3*CI1)/1E3;
T1 = [candidatePredictors, Stats(:, [2 1]), num2cell([B1, P1, OR1]), num2cell(CI1, 2)];

