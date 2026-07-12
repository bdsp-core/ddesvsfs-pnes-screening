function DDESVSFS_calculator
clc
close all

    f = figure('units','normalized','outerposition',[0 0.1 .5 .8]);
    set(f,'HitTest','off')
    set(f,'WindowButtonDownFcn',@clicks_Callback);
    set(f,'ButtonDownFcn',@clicks_Callback);
    set(f,'KeyPressFcn',@keys_Callback);
    
    
    titleStr = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.9    0.8   0.05],'string','The DDESVSFS Calculator', 'fontsize', 18,'fontweight', 'bold' );      
    introStr = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.85    0.9   0.05],'string','Please import the following clinical information to create a risk of the seizures being epileptic:', 'fontsize', 15, 'HorizontalAlignment', 'left');     
    
    
    % 8 input preditors - questions %
    predictorStr01 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.80    0.6   0.05],'string','Q1: Is the routine EEG test normal?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr02 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.75    0.6   0.05],'string','Q2: Are there predisposing factors for functional seizures?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr03 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.70    0.6   0.05],'string','Q3: Is the seizure semiology suggestive of functional seizures?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr04 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.65    0.6   0.05],'string','Q4: How long is the disease duration?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr05 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.60    0.6   0.05],'string','Q5: How many comorbidities are there?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr06 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.55    0.6   0.05],'string','Q6: How often does the patient have seizures?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr07 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.50    0.6   0.05],'string','Q7: How many antiepileptic drugs are currently prescribed?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    predictorStr08 = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.45    0.6   0.05],'string','Q8: Is there compliance with the prescribed antiepileptic drugs?', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    
    % Input panel for answers %
    answer01a = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.7    0.81    0.1   0.05],'string','Yes', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A1a);      
    answer01b = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.8    0.81    0.1   0.05],'string','No', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A1b);      
    answer02a = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.7    0.76    0.1   0.05],'string','Yes', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A2a);         
    answer02b = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.8    0.76    0.1   0.05],'string','No', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A2b);          
    answer03a = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.7    0.71    0.1   0.05],'string','Yes', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A3a);           
    answer03b = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.8    0.71    0.1   0.05],'string','No', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A3b);            
    answer04a  = uicontrol(f,'style','edit', 'units','normalized','position',[0.7    0.66    0.1   0.05],'string', '', 'fontsize', 15, 'HorizontalAlignment', 'right');      
    answer04b  = uicontrol(f,'style','text', 'units','normalized','position',[0.8    0.65    0.1   0.05],'string',' years', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    answer05a  = uicontrol(f,'style','edit', 'units','normalized','position',[0.7    0.61    0.1   0.05],'string', '', 'fontsize', 15, 'HorizontalAlignment', 'right');      
    answer05b  = uicontrol(f,'style','text', 'units','normalized','position',[0.8    0.60    0.2   0.05],'string',' comorbidities', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    answer06a  = uicontrol(f,'style','edit', 'units','normalized','position',[0.7    0.56    0.1   0.05],'string','', 'fontsize', 15, 'HorizontalAlignment', 'right');      
    answer06b  = uicontrol(f,'style','text', 'units','normalized','position',[0.8    0.55    0.2   0.05],'string',' seizures/month', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    answer07a  = uicontrol(f,'style','edit', 'units','normalized','position',[0.7    0.51    0.1   0.05],'string','', 'fontsize', 15, 'HorizontalAlignment', 'right');      
    answer07b  = uicontrol(f,'style','text', 'units','normalized','position',[0.8    0.50    0.1   0.05],'string',' AEDs', 'fontsize', 15, 'HorizontalAlignment', 'left');         
    answer08a = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.7    0.46    0.1   0.05],'string','Yes', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A8a);          
    answer08b = uicontrol(f,'style','radiobutton', 'units','normalized','position',[0.8    0.46    0.1   0.05],'string','No', 'fontsize', 15, 'HorizontalAlignment', 'left', 'callback',@fcn_A8b);            
    
    % Do button %
    calculate = uicontrol(f,'style','pushbutton','units','normalized',  'position',[0.05    0.40    0.15   0.05], 'string','Calculate', 'fontsize', 15, 'callback',@fcn_calculate);      
     
    % Panel for results %
    points = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.30    0.3   0.05],'string','Total score: ', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    esRisk  = uicontrol(f,'style','text', 'units','normalized','position',[0.05    0.25    0.3   0.05],'string','ES risk: ', 'fontsize', 15, 'HorizontalAlignment', 'left');      
    footStr = uicontrol(f,'style','text', 'units','normalized','position',[0.05    -0.02    1   0.05],'string','The provided risk is based on the DDESVSFS prediction score, which is a research tool. Clinical decisions should be based on video-EEG confirmation and medical judgement.'....
        , 'fontsize', 8, 'HorizontalAlignment', 'left');      

    % Axis for calibration %
    ax_cali     = subplot('position',[.5  .08 .35  .35]); 
    
    startx = uicontrol(f,'style','pushbutton','units','normalized', 'position',[0.46    0.58    0.1    0.05], 'string','Start', 'fontsize', 15, 'callback',@fcn_start);      
     
    % Hide all %
%     set(ax_cali, 'Visible', 'off');
    set(predictorStr01, 'Visible', 'off');
    set(predictorStr02, 'Visible', 'off');
    set(predictorStr03, 'Visible', 'off');
    set(predictorStr04, 'Visible', 'off');
    set(predictorStr05, 'Visible', 'off');
    set(predictorStr06, 'Visible', 'off');
    set(predictorStr07, 'Visible', 'off');
    set(predictorStr08, 'Visible', 'off');
    set(answer01a, 'Visible', 'off');set(answer01b, 'Visible', 'off');
    set(answer02a, 'Visible', 'off');set(answer02b, 'Visible', 'off');
    set(answer03a, 'Visible', 'off');set(answer03b, 'Visible', 'off');
    set(answer04a, 'Visible', 'off');set(answer04b, 'Visible', 'off');
    set(answer05a, 'Visible', 'off');set(answer05b, 'Visible', 'off');
    set(answer06a, 'Visible', 'off');set(answer06b, 'Visible', 'off');
    set(answer07a, 'Visible', 'off');set(answer07b, 'Visible', 'off');
    set(answer08a, 'Visible', 'off');set(answer08b, 'Visible', 'off');
    set(calculate, 'Visible', 'off');
    set(points, 'Visible', 'off');
    set(esRisk, 'Visible', 'off');
    
    x = [];
    xx = [];
    yy = [];
    Cali_err_mean = [];
    Tab2 = [];
    M = [];
    idx = [];
    
    yp = NaN;
    pts_total = NaN;
    pts_eegNormal = NaN;
    pts_rfPNES = NaN;
    pts_PNESsuggestive = NaN;
    pts_compliantAED = NaN;
    pts_comorbidities = NaN;
    pts_duration = NaN;
    pts_szFreq = NaN;
    pts_noAEDs = NaN;
    
    uiwait(f);
    while true 
        if isnan(yp)
            
            cla(ax_cali)
            set(ax_cali, 'Visible', 'off');
            set(points, 'string', 'Total score:', 'fontsize', 15)
            set(esRisk, 'string', 'ES risk:', 'fontsize', 15)
            
            
        else
            set(ax_cali, 'Visible', 'on');
            set(points, 'string', ['Total score: ',num2str(pts_total), ' points'], 'fontsize', 15)
            set(esRisk, 'string', ['ES risk: ', num2str(round(1000*yp)/10), '%'], 'fontsize', 15)
            
            set(f,'CurrentAxes', ax_cali);cla(ax_cali)
            hold(ax_cali, 'on')
                plot(ax_cali, linspace(0, 1, 100), linspace(0, 1, 100), 'k--');
                patch(ax_cali, x, yy,'b','facealpha',.6,'edgecolor','none','facecolor',[.7 .7 .7]); 
                plot(ax_cali, xx, M,'k','linewidth',2);

                text(ax_cali, .55, .4, ['Cali. error = ', num2str(round(Cali_err_mean*10000)/10000)])

                fill(ax_cali, [.6 .6 .8 .8], [.1 .15 .15 .1], [.8 .8 .8],'edgecolor', 'w')
                text(ax_cali, .82, .13, '95% CI')
                axis square
                grid on
                title('Calibration')
                xlabel('Predicted')
                ylabel('Observed')

                % plot Epilepsy risk points on the Cali %
                tmp_y = interp1(xx, M, Tab2(:, 2));
                plot(ax_cali, Tab2(:, 2), tmp_y, 'r.', 'markersize', 30)
                
                plot(ax_cali, Tab2(idx, 2), tmp_y(idx), 'go', 'markersize', 30, 'linewidth', 2)
                for k = 5:11%1:length(Tab2)
                    if k>9
                        text(ax_cali, Tab2(k, 2)-.05, tmp_y(k)+.02*(k-11), [num2str(Tab2(k, 1)), ' points'], 'horizontalalignment', 'right', 'color', 'blue')       
                    else
                        text(ax_cali, Tab2(k, 2)+.03, tmp_y(k), [num2str(Tab2(k, 1)), ' points'], 'horizontalalignment', 'left', 'color', 'blue')
                    end
                end
            hold(ax_cali, 'off')
        end
        
        uiwait(f);
    end
    
     % Start %
    function fcn_start(varargin) 
        set(startx,'Visible','off','Enable', 'off');
        loading = uicontrol(f,'style','text','units','normalized','position',[0.46    0.58    0.1    0.05],'string','Loading...','FontSize',15);
        
        tmp = load('cali_plot.mat');
        x = tmp.x;
        xx = tmp.xx;
        yy = tmp.yy;
        Cali_err_mean = .076;%tmp.Cali_err_mean;
        Tab2 = tmp.Tab2;
        M = tmp.M;
        
        delete(loading)
        
        %set(ax_cali, 'Visible', 'on');
        set(predictorStr01, 'Visible', 'on');
        set(predictorStr02, 'Visible', 'on');
        set(predictorStr03, 'Visible', 'on');
        set(predictorStr04, 'Visible', 'on');
        set(predictorStr05, 'Visible', 'on');
        set(predictorStr06, 'Visible', 'on');
        set(predictorStr07, 'Visible', 'on');
        set(predictorStr08, 'Visible', 'on');
        set(answer01a, 'Visible', 'on');set(answer01b, 'Visible', 'on');
        set(answer02a, 'Visible', 'on');set(answer02b, 'Visible', 'on');
        set(answer03a, 'Visible', 'on');set(answer03b, 'Visible', 'on');
        set(answer04a, 'Visible', 'on');set(answer04b, 'Visible', 'on');
        set(answer05a, 'Visible', 'on');set(answer05b, 'Visible', 'on');
        set(answer06a, 'Visible', 'on');set(answer06b, 'Visible', 'on');
        set(answer07a, 'Visible', 'on');set(answer07b, 'Visible', 'on');
        set(answer08a, 'Visible', 'on');set(answer08b, 'Visible', 'on');
        set(calculate, 'Visible', 'on');
        set(points, 'Visible', 'on');
        set(esRisk, 'Visible', 'on');
           
        uiresume(f);
    end

    function fcn_A1a(source, event)
        set(answer01b, 'value', 0);
        drawnow;
        
        pts_eegNormal = -3; % yes %
        uiresume(f);
    end
    function fcn_A1b(source, event)
        set(answer01a, 'value', 0);
        drawnow;
        
        pts_eegNormal = 0; % no %
        uiresume(f);
    end
    
    function fcn_A2a(source, event)
        set(answer02b, 'value', 0);
        drawnow;
        
        pts_rfPNES = -3; % yes %
        uiresume(f);
    end
    function fcn_A2b(source, event)
        set(answer02a, 'value', 0);
        drawnow;
        
        pts_rfPNES = 0;
        uiresume(f);
    end

    function fcn_A3a(source, event)
        set(answer03b, 'value', 0);
        drawnow;
        
        pts_PNESsuggestive = -4; % yes %
        uiresume(f);
    end
    function fcn_A3b(source, event)
        set(answer03a, 'value', 0);
        drawnow;
        
        pts_PNESsuggestive = 0;
        uiresume(f);
    end

    function fcn_A8a(source, event)
        set(answer08b, 'value', 0);
        drawnow;
        
        pts_compliantAED = 3; % yes %
        uiresume(f);
    end
    function fcn_A8b(source, event)
        set(answer08a, 'value', 0);
        drawnow;
        
        pts_compliantAED = 0; 
        uiresume(f);
    end

    function fcn_calculate(~,~)
        thr_comorbidities = 7;
        thr_szFreq = 8;
        thr_duration = 14;
        thr_noAEDs = 1;
        
        % check whether all checked/answered %
        % get continous values %
        value_duration = str2num(get(answer04a, 'string'));
        if isempty(value_duration)
            pts_duration = NaN;
        else
            pts_duration = 3*(value_duration>thr_duration);
        end
        
        value_comorbidities = str2num(get(answer05a, 'string'));
        if isempty(value_comorbidities)
            pts_comorbidities = NaN;
        else
            pts_comorbidities = -3*(value_comorbidities>thr_comorbidities);
        end
        
        value_szFreq = str2num(get(answer06a, 'string'));
        if isempty(value_szFreq)
            pts_szFreq = NaN;
        else
            pts_szFreq = -4*(value_szFreq>thr_szFreq);
        end
        
        value_noAEDs = str2num(get(answer07a, 'string'));
        if isempty(value_noAEDs)
            pts_noAEDs = NaN;
        else
            pts_noAEDs = 2*(value_noAEDs>thr_noAEDs);
        end
        
        % Total %
        pts_total = pts_eegNormal + pts_rfPNES + pts_PNESsuggestive + pts_compliantAED +...
                    pts_comorbidities + pts_duration + pts_szFreq + pts_noAEDs;
                

        if isnan(pts_total)
            yp = NaN;
            questdlg('Please answer all 8 questions!','Warning','Ok','Ok');
  
        else
            % LUT %
            idx = find(Tab2(:, 1) == pts_total);
            if length(idx)~=1
                questdlg('Error! points out of range!!!','Warning','Ok','Ok');
            else
                yp = Tab2(idx, 2);
            end
            
        end
        uiresume(f);
        
    end
end