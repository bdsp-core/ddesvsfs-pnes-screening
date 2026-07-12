clc
close all
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load model performance from feature selection %
tmp = load('featureSelected.mat');
 
y = double(tmp.y);
X = tmp.X;
nVotes = tmp.nVotes;

% multi-var L Regression %
[b2, ~,  stats2] = glmfit(X,  y, 'binomial', 'link', 'logit');
B2 = b2(2:end);
P2 = stats2.p(2:end);

OR2 = exp(B2);
CI2 = [exp(B2-1.96*stats2.se(2:end)), exp(B2+1.96*stats2.se(2:end))];

B2 = round(1E3*B2)/1E3;
OR2 = round(1E3*OR2)/1E3;
CI2 = round(1E3*CI2)/1E3;

T2 = [tmp.predictors, num2cell([nVotes, B2, P2, OR2]), num2cell(CI2, 2)];

 

