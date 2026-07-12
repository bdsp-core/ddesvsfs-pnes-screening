clc
close all
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load model performance from feature selection %
tmp = load('featureSelected.mat');
y = tmp.y;
y_hat = tmp.y_hat;
N = length(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bootstrap to get CI %
K = 10000;
for k = 1:K
    idx = randsample(N, N, 1);  % randomly sample on patients % 
    yk = y(idx);
    yk_hat = y_hat(idx);
    
    % Compute Calibarition: Fraction of poor outcome vs. Predition %
    xx = [-.1 .1 .45 .6 .9, 1.1];
    M = length(xx)-1; 
    yy = NaN(M,1);  
    for m = 1:M
        y_m = yk(yk_hat>=xx(m) & yk_hat<xx(m+1));
        yy(m) = sum(y_m)/length(y_m);
    end
    Cali(k, :) = yy;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the figure %
f = figure('units','normalized','outerposition',[0.3 0.3 .4 .4]);

% Figure S2b: Calibration with error %
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
    patch(x,yy,'b','facealpha',.6,'edgecolor','none','facecolor',[.7 .7 .7]); 
    plot(xx,M,'k','linewidth',2);
    
    cali = num2str(round(Cali_err_mean*1E3)/1E3);
    text(h2, .5, .4, ['Cali. error = ', [cali, repmat('0', 1, 5-length(cali))]])
   
    fill([.6 .6 .8 .8], [.1 .15 .15 .1], [.7, .7, .7],'edgecolor', 'w')
    text(.82, .13, '95% CI')
    
    axis square
    grid on
    title('Calibration')
    xlabel('Prediction')
    ylabel('Proportion of poor outcome')
hold(h2, 'off')

% Figure S2a: ROC %
[FARs, SENs, THRs, AUC, OptPoint] = perfcurve(y, y_hat, 1, 'NBoot', K, 'TVals', 0:0.01:1);
U = SENs(:, 3); L = SENs(:, 2); 
M = SENs(:, 1); 

xx = FARs(:, 1);

idx_opt = find(round(xx*1E4)/1E4 ==round(1E4*(OptPoint(1)))/1E4...
    & round(1E4*M)/1E4==round(1E4*OptPoint(2))/1E4);
thr = THRs(idx_opt(1));

disp(['optimal op: thr = ', num2str(thr), ' sens = ', num2str(OptPoint(2)), ' spec = ', num2str(1-OptPoint(1))])

x = [xx' fliplr(xx')];
yy = [L' fliplr(U')];

h1 = subplot(1,2,1);
pos = get(h1, 'position');
set(h1, 'position', pos+[-0.06, -0.03 0.08 0.07])
hold(h1, 'on')
    plot(h1, linspace(0, 1, 100), linspace(0, 1, 100), 'k--')
    patch(x, yy,'b','facealpha',.6,'edgecolor','none','facecolor',[.6 .6 .6]); 
    plot(xx, M,'k','linewidth',2);
    
    plot(h1, OptPoint(1), OptPoint(2), 'rx', 'markersize', 10, 'linewidth',2)
    sens = num2str(round(OptPoint(2)*1E3)/1E3);
    spec = num2str(round((1-OptPoint(1))*1E3)/1E3);
    auc = num2str(round(AUC(1)*1E3)/1E3);
    text(h1, OptPoint(1), OptPoint(2)-.1, ['sensitivity:', [sens, repmat('0', 1, 5-length(sens))],...
        '\newlinespecificity:', [spec, repmat('0', 1, 5-length(spec))]]);
  
    text(h1, .6, .4, ['AUC = ', [auc, repmat('0', 1, 5-length(auc))]]);
    
    fill([.6 .6 .8 .8], [.1 .15 .15 .1], [.7, .7, .7],'edgecolor', 'w')
    text(.82, .13, '95% CI')
  
    title('10-fold CV ROC')
    axis square
    grid on
    xlabel('1-Specificity')
    ylabel('Sensitivity')
hold(h1, 'off')

% AUC [CI], Cali. err [CI], operating point [spec, sens] %
performScrs = [AUC; Cali_err_mean, Cali_err_lower, Cali_err_upper]
OptPoint    = [1-OptPoint(1), OptPoint(2)]

print(gcf, '-dpng', '-r300', 'Figure_ROC_Calibration.png');
