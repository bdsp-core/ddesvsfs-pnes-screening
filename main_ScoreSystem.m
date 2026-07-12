clc
close all
clear

warning('off')
K = 10000;

% load model performance from feature selection %
tmp = load('.\featureSelected.mat');
y = tmp.y;
Xo = tmp.X; 
nVotes = tmp.nVotes;
predictorso  = tmp.predictors;

X = Xo;
% convert each continous predictor to binary 0 or 1 by group median %
x_mean = floor(mean(Xo, 1));
Xn = (Xo>repmat(x_mean, size(Xo, 1), 1));
X(:, [4 7 9]) = Xn(:, [4 7 9]);

% step1: remove predictors occure <5 times %
idx = find(nVotes>5);
X = X(:, idx); 
predictors = predictorso(idx);

% M1 - New model trained on final selected/combined clincal predictors only %
b = glmfit(X, y, 'binomial', 'logit');
y_hat1  = glmval(b, X,'logit');

[~, ~, ~, AUC1] = perfcurve(y, y_hat1, 1);  % 0.8661
disp(['M1 clinical AUC: ', num2str(AUC1)]);

% M2a - Rounded up weights except intersect B0 - opt to have min AUC %
bestAUC = floor(AUC1*10)/10; bestB = b; 
for i = 1:K
    bb = round(b+.5*randn(size(b)));  % rounding up the coeff. b1 to b5 %
    bb(1) = b(1);                     % except for the intercept B0 %
    Yh = glmval(bb, X, 'logit');      % new prediction on rounded coeff. %
    [~, ~, ~, AUC] = perfcurve(y, Yh, 1);
    if AUC>bestAUC 
        bestAUC = AUC; 
        disp(['auc: ', num2str(AUC)]); 
        y_hat2a = Yh;
        bestB = bb; 
        AUC2a = bestAUC;       
    end
end
disp(['M2a clinical AUC: ', num2str(AUC2a)]);
disp(['B0a = ', num2str(bestB(1))]); 

% M2b - finetune the intersect B0 to have min MAE wrt original yp_hat %
bestMAE = Inf;
for i = 1:K
    bb = [bestB(1)+.1*randn(1); bestB(2:end)]; % fix all other weigths %
    Yh = glmval(bb, X, 'logit');               % new prediction on shifted B0 %
    mae = mean(abs(y_hat1 - Yh));
    
    if mae<bestMAE
        bestMAE = mae; 
        %disp(['mae: ', num2str(mae)]);
        
        bestB = bb; 
        y_hat2b = Yh;
        [~, ~, ~, AUC2b] = perfcurve(y, Yh, 1); 
    end
end
disp(['M2b clinical AUC: ', num2str(AUC2b)]);
disp(['B0b = ', num2str(bestB(1))]); 
for i = 2:length(bestB)
   disp([repmat(' ', 1, 2-length(num2str(bestB(i)))), num2str(bestB(i)), '    '  predictors{i-1}  ]) 
end
bpre = bestB;
z1 = X*bpre(2:end);

% epilepsy risk as function of score z %
er_score  = y_hat2b;
er_point  = X*bpre(2:end);         % z score from weighted sum on 2nd model M2 %
[~, idx] = unique(er_point);
Tab2 = [er_point(idx), round(100*er_score(idx))/100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_hat = y_hat2b;

%%%% Figure %%%%
f = figure('units','normalized','outerposition',[0.3 0.3 .4 .4]);

% Figure 1A - ROC of model LR with rounding %
[FARs, SENs, THRs, AUC, OptPoint] = perfcurve(y, y_hat, 1, 'NBoot', K, 'TVals', 0:0.01:1);
performAUCwithCI = AUC

M = SENs(:, 1); U = SENs(:, 3); L = SENs(:, 2); 
xx = FARs(:, 1); x = [xx' fliplr(xx')]; yy = [L' fliplr(U')];

idx_opt = find(round(xx*1E4)/1E4 ==round(1E4*OptPoint(1))/1E4...
    & round(1E4*M)/1E4==round(1E4*OptPoint(2))/1E4);
thr = THRs(idx_opt(1));

disp(['optimal op: thr = ', num2str(thr), ' sens = ', num2str(OptPoint(2)), ' spec = ', num2str(1-OptPoint(1))])

h1 = subplot(1, 2, 1);
pos = get(h1, 'position');
set(h1, 'position', pos+[-0.06, -0.03 0.08 0.07])
hold(h1, 'on')
    plot(h1, linspace(0, 1, 100), linspace(0, 1, 100), 'k--')
    patch(h1, x, yy,'b','facealpha',.6,'edgecolor','none','facecolor', [.7 .7 .7]); 
    plot(h1, xx, M,'k','linewidth',2);
    
    plot(h1, OptPoint(1), OptPoint(2), 'rx', 'markersize', 10, 'linewidth',2)
    sens = num2str(round(OptPoint(2)*1E3)/1E3);
    spec = num2str(round((1-OptPoint(1))*1E3)/1E3);
    
    text(h1, OptPoint(1), OptPoint(2)-.1, ['sensitivity:', [sens, repmat('0', 1, 5-length(sens))],...
        '\newlinespecificity:', [spec, repmat('0', 1, 5-length(spec))]]);
  
    
    text(h1, .6, .4, ['AUC = ', num2str(round(AUC(1)*1E3)/1E3)]);
    fill(h1, [.6 .6 .8 .8], [.1 .15 .15 .1], [.8 .8 .8],'edgecolor', 'w')
    text(h1, .82, .13, '95% CI')
  
    title('(A) ROC')
    axis square
    grid on
    xlabel('1-Specificity')
    ylabel('Sensitivity')
hold(h1, 'off')

% Figure 1B - Calibration of model LR1 w/o rounding %
N = length(y);
for k = 1:K % bootstrap to get CI %
    idx = randsample(N, N, 1);  % randomly sample on patients % 
    
    yk = y(idx); yk_hat = y_hat(idx);
 
    % Compute Calibarition: Fraction of poor outcome vs. Predition %
    xx = [-.1 .1 .45 .6 .9, 1.1];
    %xx = -.1:.2:1.1;
    
    M = length(xx)-1; 
    yy = NaN(M,1);
    for m = 1:M
        y_m = yk(yk_hat>=xx(m) & yk_hat<xx(m+1));
        yy(m) = sum(y_m)/length(y_m);
    end
    Cali(k, :) = yy;
end

idx = ~isnan(nanmean(Cali, 1));
xx = (xx(2:end)+xx(1:end-1))/2; 
xx = xx(idx);
Cali = Cali(:, idx==1);


% Cali Error with CI to report %
Cali_err = nanmean(abs(Cali-repmat(xx, size(Cali, 1), 1)), 2);
Cali_err_upper = prctile(Cali_err, 97.5); Cali_err_lower = prctile(Cali_err, 2.5); 
Cali_err_mean = nanmean(Cali_err); 
performCaliwithCI = [Cali_err_mean Cali_err_lower Cali_err_upper]

M = nanmean(Cali, 1); U = prctile(Cali, 97.5); L = prctile(Cali, 2.5); 
x  = [xx fliplr(xx)];
yy = [L fliplr(U)];

h2 = subplot(1,2,2);
pos = get(h2, 'position');
set(h2, 'position', pos+[0.00, -0.03 0.08 0.07])
hold(h2, 'on')
    plot(h2, linspace(0, 1, 100), linspace(0, 1, 100), 'k--');
    patch(h2, x, yy,'b','facealpha',.6,'edgecolor','none','facecolor',[.7 .7 .7]); 
    plot(h2, xx, M,'k','linewidth',2);
    
    text(h2, .55, .4, ['Cali. error = ', num2str(round(Cali_err_mean*10000)/10000)])
   
    fill(h2, [.6 .6 .8 .8], [.1 .15 .15 .1], [.8 .8 .8],'edgecolor', 'w')
    text(h2, .82, .13, '95% CI')
    axis square
    grid on
    title('(B) Calibration')
    xlabel('Predicted')
    ylabel('Observed')
    
    % plot Epilepsy risk points on the Cali %
    tmp_y = interp1(xx, M, Tab2(:, 2));
    plot(h2, Tab2(:, 2), tmp_y, 'r.', 'markersize', 30)
    for k = 5:11%1:length(Tab2)
 
        if k>9
            text(h2, Tab2(k, 2)-.05, tmp_y(k)+.02*(k-11), [num2str(Tab2(k, 1)), ' points'], 'horizontalalignment', 'right', 'color', 'blue')
%         elseif k<5
%             text(h2, Tab2(k, 2)+.02*(k-3), tmp_y(k)+.03*(k-3), [num2str(Tab2(k, 1)), ' points'], 'horizontalalignment', 'left', 'color', 'blue')
%       

        else
            
            text(h2, Tab2(k, 2)+.03, tmp_y(k), [num2str(Tab2(k, 1)), ' points'], 'horizontalalignment', 'left', 'color', 'blue')
%        
        end
    end

hold(h2, 'off')

print(gcf, '-dpng', '-r300', 'Figure1_scoreSystem.png');


