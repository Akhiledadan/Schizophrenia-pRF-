function [params_comp,opt] = SZ_pA_plotParameters(params_comp,opt,dirPth)
% SZ_pA_plotParameters - function to make the plots for subject average
% responses for sigma - 2D gaussian fit (raw distribution, fit line, AUC)
%
%
% 07/10/2019: written by Akhil Edadan (a.edadan@uu.nl)

conditions = opt.conditions;
numCond    = length(conditions);
numRoi     = length(opt.rois);

xfit = linspace(opt.xFitRange(1),opt.xFitRange(2),20);

% change colors here
color_map = [1 0.5 0.5;...
    0.5 1 0.5;...
    0.5 0.5 1;...
    0.5 0.5 0.5];

numSubMax = max([length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]);

sub_count = 1;
params_comp.fit_slope = nan(numCond,numSubMax,numRoi);
params_comp.auc       = nan(numCond,numSubMax,numRoi);
params_comp.cen       = nan(numCond,numSubMax,numRoi);
for cond_idx = 1:numCond
    
    curCond = conditions{cond_idx};
    switch curCond
        case 'ptH'
            subjects = opt.subjects.ptH;
        case 'ptNH'
            subjects = opt.subjects.ptNH;
        case 'HC'
            subjects = opt.subjects.HC;
    end
    
    numSub = length(subjects);
    
    for sub_idx = 1:numSub
        curSub = subjects{sub_idx};
        
        for roi_idx = 1:numRoi
            curRoi = opt.rois{roi_idx};
            
            % fit
            [params_comp.y_comp_fit{cond_idx,sub_idx,roi_idx},params_comp.b_fit{cond_idx,sub_idx,roi_idx}] = NP_fit(params_comp.x_comp{cond_idx,sub_idx,roi_idx},params_comp.y_comp{cond_idx,sub_idx,roi_idx},...
                params_comp.ve_comp{cond_idx,sub_idx,roi_idx},xfit');
            
            params_comp.fit_slope(cond_idx,sub_idx,roi_idx) = params_comp.b_fit{cond_idx,sub_idx,roi_idx}.p(1); % slope of the fitted line on pRf size vs eccentricity distribution
            % select the subjects with negative prf size eccentricity relation
            if params_comp.fit_slope(cond_idx,sub_idx,roi_idx) < 0
                opt.subExcluded{sub_count} = curSub;
                sub_count = sub_count+1;
            end
            
            % Bootstrap the data and bin the x parameter
            x_param  = params_comp.x_comp{cond_idx,sub_idx,roi_idx};
            y_param  = params_comp.y_comp{cond_idx,sub_idx,roi_idx};
            w = params_comp.ve_comp{cond_idx,sub_idx,roi_idx};
            [params_comp.y_comp_binData{cond_idx,sub_idx,roi_idx},params_comp.y_comp_binDataUpper{cond_idx,sub_idx,roi_idx},params_comp.y_comp_binDataLower{cond_idx,sub_idx,roi_idx}] =  SZ_bin_param(x_param,y_param,w,xfit,opt);
            
            % compute area under curve
            [params_comp.auc(cond_idx,sub_idx,roi_idx),~,~,~,~] = SZ_AUC(xfit,params_comp.y_comp_fit{cond_idx,sub_idx,roi_idx},opt); % flag - take difference between AUCs
            
            % compute pRF size at a central eccentricity
            b = params_comp.b_fit{cond_idx,sub_idx,roi_idx}.p;
            [params_comp.cen(cond_idx,sub_idx,roi_idx),~,~,~,~,~] = SZ_CEN(b,opt); % flag - take difference between AUCs
            
            
        end
        
    end
end



if opt.detailedPlot
    % plot the figures if asked to
    if opt.verbose
        
        for cond_idx = 1:numCond
            
            curCond = conditions{cond_idx};
            switch curCond
                case 'ptH'
                    subjects = opt.subjects.ptH;
                case 'ptNH'
                    subjects = opt.subjects.ptNH;
                case 'HC'
                    subjects = opt.subjects.HC;
            end
            
            numSub = length(subjects);
            
            n_rows = 4;
            n_cols = 4;
            
            % FIGURE 3
            figName31 = sprintf('%s vs eccentricity','sigma');
            fH31 = figure(31); set(gcf, 'Color', 'w', 'Position',[100 100 1920 1080], 'Name', figName31,'PaperPositionMode', 'auto'); clf;
            
            figName32 = sprintf('%s vs eccentricity','sigma');
            fH32 = figure(32); set(gcf, 'Color', 'w', 'Position',[100 100 1920 1080], 'Name', figName32,'PaperPositionMode', 'auto'); clf;
            
            figName33 = sprintf('%s vs eccentricity','variance explained');
            fH33 = figure(33); set(gcf, 'Color', 'w', 'Position',[100 100 1920 1080], 'Name', figName33,'PaperPositionMode', 'auto'); clf;
            
            figName34 = sprintf('Distribution of %s',opt.plotType);
            fH34 = figure(34); set(gcf, 'Color', 'w', 'Position',[100 100 1920 1080], 'Name', figName34,'PaperPositionMode', 'auto'); clf;
            
            for sub_idx = 1:numSub
                curSub = subjects{sub_idx};
                
                figure(31); subplot(n_rows,n_cols,sub_idx);
                figure(32); subplot(n_rows,n_cols,sub_idx);
                figure(33); subplot(n_rows,n_cols,sub_idx);
                figure(34); subplot(n_rows,n_cols,sub_idx);
                
                for roi_idx = 1:numRoi
                    curRoi = opt.rois{roi_idx};
                    figure(31); hold on;
                    plot(params_comp.x_comp{cond_idx,sub_idx,roi_idx},params_comp.y_comp{cond_idx,sub_idx,roi_idx},'.','color',color_map(roi_idx,:),'MarkerSize',10);
                    xlabel('eccentricity (degrees)'); ylabel(sprintf('%s',opt.yAxis));
                    ylim(opt.yaxislim);
                    
                    figure(32); hold on;
                    plot(xfit,params_comp.y_comp_fit{cond_idx,sub_idx,roi_idx},'color',color_map(roi_idx,:),'LineWidth',3);
                    xlabel('eccentricity (degrees)'); ylabel(sprintf('%s',opt.yAxis));
                    ylim(opt.yaxislim);
                    
                    figure(33); hold on;
                    plot(params_comp.x_comp{cond_idx,sub_idx,roi_idx},params_comp.ve_comp{cond_idx,sub_idx,roi_idx}.*100,'.','color',color_map(roi_idx,:),'MarkerSize',10);
                    xlabel('eccentricity (degrees)'); ylabel('variance explained (%)');
                    ylim([0 100]);
                    
                    figure(34); hold on;
                    histogram(params_comp.y_comp{cond_idx,sub_idx,roi_idx},100,'BinLimits',[0 prctile(params_comp.y_comp{cond_idx,sub_idx,roi_idx},95)]);
                    xlabel(opt.yAxis); ylabel('frequency');
                    
                end
                figure(31);legend(opt.rois,'Location','northeastoutside');
                figure(32);legend(opt.rois,'Location','northeastoutside');
                figure(33);legend(opt.rois,'Location','northeastoutside');
                hold off;
                
            end
            
            % save figures for each condition
            if opt.saveFig
                saveDir = fullfile(dirPth.saveDirMSFig,'figure3',sprintf('figure3_%s_%s',curCond,opt.plotType));
                if ~exist(saveDir,'dir')
                    mkdir(saveDir);
                end
                
                % figure 31
                figName = figName31;
                figName(regexp(figName,' ')) = '_';
                filename                     = figName;
                fullFilename                 = sprintf([filename,'_raw_%s'],curCond);
                print(fH31, fullfile(saveDir,fullFilename), '-dpng');
                
                print(fH31, fullfile(saveDir,fullFilename), '-depsc2');
                
                % figure 32
                figName = figName32;
                figName(regexp(figName,' ')) = '_';
                filename                     = figName;
                fullFilename                 = sprintf([filename,'_fit_%s'],curCond);
                print(fH32, fullfile(saveDir,fullFilename), '-dpng');
                
                % figure 33
                figName = figName33;
                figName(regexp(figName,' ')) = '_';
                filename                     = figName;
                fullFilename                 = sprintf([filename,'_ve_%s'],curCond);
                print(fH33, fullfile(saveDir,fullFilename), '-dpng');
                
                % figure 34
                figName = figName34;
                figName(regexp(figName,' ')) = '_';
                filename                     = figName;
                fullFilename                 = sprintf([filename,'_dist_%s'],curCond);
                print(fH34, fullfile(saveDir,fullFilename), '-dpng');
                
            end
        end
    end
end
end % end of function