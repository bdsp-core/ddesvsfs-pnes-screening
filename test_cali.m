clc
close all
clear 
 
load('cali_plot.mat')
figure
h2 = gca;

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