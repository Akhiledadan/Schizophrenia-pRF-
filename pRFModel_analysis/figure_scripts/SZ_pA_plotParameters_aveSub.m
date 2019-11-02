function [params_comp,opt] = SZ_pA_plotParameters_aveSub(params_comp,opt,dirPth)
% SZ_pA_plotParameters_aveSub - function to make the plots for subject average
% responses
%
%
% 07/10/2019: written by Akhil Edadan (a.edadan@uu.nl)

conditions = opt.conditions;
numCond = length(conditions);

color_map = [0.5 1 0.5;...
    0.5 0.5 1;...
    1 0.5 0.5;...
    ];

numRoi = length(opt.rois);
numSubMax = max([length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]);

% restructure the matrix so that averge across subjects can be calculated
numBin = size(params_comp.y_comp_binData{1,1,1}.y,2);
y_params_toAverage = nan(numBin,numCond,numSubMax,numRoi);
x_params_toAverage = nan(numBin,numCond,numSubMax,numRoi);
for cond_idx=1:numCond % loop over every condition
    curCond = conditions{cond_idx};
    switch curCond
        case 'SZ-VH'
            subjects = opt.subjects.ptH;
        case 'SZ-nVH'
            subjects = opt.subjects.ptNH;
        case 'HC'
            subjects = opt.subjects.HC;
    end
    numSub = length(subjects);
    
    for sub_idx=1:numSub % loop over every subject
        for roi_idx=1:numRoi
            y_params_toAverage_tmp = params_comp.y_comp_binData{cond_idx,sub_idx,roi_idx}.y;
            x_params_toAverage_tmp = params_comp.y_comp_binData{cond_idx,sub_idx,roi_idx}.x;
            
            y_params_toAverage(:,cond_idx,sub_idx,roi_idx)     = y_params_toAverage_tmp;
            x_params_toAverage(:,cond_idx,sub_idx,roi_idx)     = x_params_toAverage_tmp;
        end
    end
end

% Compute average of the pRF parameter across subjects for each of roi
y_params_Average = nanmean(y_params_toAverage,3);
x_params_Average = nanmean(x_params_toAverage,3);
y_params_Average_std = nanstd(y_params_toAverage,[],3);
x_params_Average_std = nanstd(x_params_toAverage,[],3);


% Initialize the variables for auc and central values
params_AverageAuc = nan(numCond,numRoi);
params_AverageCen = nan(numCond,numRoi);
params_ToAverageDiff = struct();


%%
% fit a line to the average across subjects - # bins x # conditions x # subjects

xFit = linspace(opt.xFitRange(1),opt.xFitRange(2),20);

for roi_idx = 1:numRoi  % for every roi
    curRoi = opt.rois{roi_idx};
    
    y_params_AverageToFit = squeeze(y_params_Average(:,:,:,roi_idx));
    x_params_AverageToFit = squeeze(x_params_Average(:,:,:,roi_idx));
    
    for cond_idx = 1:numCond % for every condition
        opt.aucDifference = 0;
        opt.cenDifference = 0;
        % fit a line to the average across the subjects
        x    = x_params_AverageToFit(:,cond_idx);
        y    = y_params_AverageToFit(:,cond_idx);
        w    = [];
        [params_AverageFit.fit{cond_idx,roi_idx},params_AverageFit.b{cond_idx,roi_idx}] = NP_fit(x,y,w,xFit'); % fit the line
        
        % compute area under curve
        [params_AverageAuc(cond_idx,roi_idx),~,~,~,~] = SZ_AUC(xFit,params_AverageFit.fit{cond_idx,roi_idx},opt); % flag - take difference between AUCs
        
        % compute pRF size at a central eccentricity
        b(:,cond_idx) = params_AverageFit.b{cond_idx,roi_idx}.p;
        [params_AverageCen(cond_idx,roi_idx),~,~,~,~,~] = SZ_CEN(b(:,cond_idx),opt); % flag - take difference between AUCs
    end
    
    
    % difference between different conditions
    %1. HC - ptH
    params_ToAverageDiff.AUC.HCPtH(:,1,roi_idx) = params_AverageFit.fit{3,roi_idx};
    params_ToAverageDiff.AUC.HCPtH(:,2,roi_idx) = params_AverageFit.fit{1,roi_idx};
    params_ToAverageDiff.AUC.HCPtH_x(:,1,roi_idx) = xFit;
    params_ToAverageDiff.AUC.HCPtH_x(:,2,roi_idx) = xFit;
    % fit stats
    params_ToAverageDiff.CEN.HCPtH_b(:,1,roi_idx) = params_AverageFit.b{3,roi_idx}.p;
    params_ToAverageDiff.CEN.HCPtH_b(:,2,roi_idx) = params_AverageFit.b{1,roi_idx}.p;
    
    %2. HC - ptNH
    params_ToAverageDiff.AUC.HCPtNH(:,1,roi_idx) = params_AverageFit.fit{3,roi_idx};
    params_ToAverageDiff.AUC.HCPtNH(:,2,roi_idx) = params_AverageFit.fit{2,roi_idx};
    params_ToAverageDiff.AUC.HCPtNH_x(:,1,roi_idx) = xFit;
    params_ToAverageDiff.AUC.HCPtNH_x(:,2,roi_idx) = xFit;
    % fit stats
    params_ToAverageDiff.CEN.HCPtNH_b(:,1,roi_idx) = params_AverageFit.b{3,roi_idx}.p;
    params_ToAverageDiff.CEN.HCPtNH_b(:,2,roi_idx) = params_AverageFit.b{2,roi_idx}.p;
    
    %3. ptNH - ptH
    params_ToAverageDiff.AUC.PtNHPtH(:,1,roi_idx) = params_AverageFit.fit{2,roi_idx};
    params_ToAverageDiff.AUC.PtNHPtH(:,2,roi_idx) = params_AverageFit.fit{1,roi_idx};
    params_ToAverageDiff.AUC.PtNHPtH_x(:,1,roi_idx) = xFit;
    params_ToAverageDiff.AUC.PtNHPtH_x(:,2,roi_idx) = xFit;
    % fit stats
    params_ToAverageDiff.CEN.PtNHPtH_b(:,1,roi_idx) = params_AverageFit.b{2,roi_idx}.p;
    params_ToAverageDiff.CEN.PtNHPtH_b(:,2,roi_idx) = params_AverageFit.b{1,roi_idx}.p;
    
end


% Compute auc and central value for the difference between conditions

params_AverageDiff = struct();
xFit = linspace(opt.xFitRange(1),opt.xFitRange(2),20);
for roi_idx = 1:numRoi  % for every roi
    curRoi = opt.rois{roi_idx};
    
    opt.aucDifference = 1;
    opt.cenDifference = 1;
    
    %1. HC - ptH
    yDiffAuc_HCPtH = params_ToAverageDiff.AUC.HCPtH(:,:,roi_idx);
    xDiffAuc_HCPtH = params_ToAverageDiff.AUC.HCPtH_x(:,:,roi_idx);
    [~,~,params_AverageDiff.AUC.HCPtH(:,roi_idx),~,~,~]     = SZ_AUC(xDiffAuc_HCPtH,yDiffAuc_HCPtH,opt); % flag - take difference between AUCs
    
    % compute central value difference
    bDiffCen_HCPtH = params_ToAverageDiff.CEN.HCPtH_b(:,:,roi_idx);
    [~,~,params_AverageDiff.CEN.HCPtH(:,roi_idx),~,~,~]   = SZ_CEN(bDiffCen_HCPtH,opt); % flag - take difference between AUCs
    
    %2. HC - ptNH
    yDiffAuc_HCPtNH = params_ToAverageDiff.AUC.HCPtNH(:,:,roi_idx);
    xDiffAuc_HCPtNH = params_ToAverageDiff.AUC.HCPtNH_x(:,:,roi_idx);
    [~,~,params_AverageDiff.AUC.HCPtNH(:,roi_idx),~,~,~]     = SZ_AUC(xDiffAuc_HCPtNH,yDiffAuc_HCPtNH,opt); % flag - take difference between AUCs
    
    % compute central value difference
    bDiffCen_HCPtNH = params_ToAverageDiff.CEN.HCPtNH_b(:,:,roi_idx);
    [~,~,params_AverageDiff.CEN.HCPtNH(:,roi_idx),~,~,~]   = SZ_CEN(bDiffCen_HCPtNH,opt); % flag - take difference between AUCs
    
    %2. ptH - ptNH
    yDiffAuc_PtNHPtH = params_ToAverageDiff.AUC.PtNHPtH(:,:,roi_idx);
    xDiffAuc_PtNHPtH = params_ToAverageDiff.AUC.PtNHPtH_x(:,:,roi_idx);
    [~,~,params_AverageDiff.AUC.PtNHPtH(:,roi_idx),~,~,~]     = SZ_AUC(xDiffAuc_PtNHPtH,yDiffAuc_PtNHPtH,opt); % flag - take difference between AUCs
    
    % compute central value difference
    bDiffCen_PtNHPtH = params_ToAverageDiff.CEN.PtNHPtH_b(:,:,roi_idx);
    [~,~,params_AverageDiff.CEN.PtNHPtH(:,roi_idx),~,~,~]   = SZ_CEN(bDiffCen_PtNHPtH,opt); % flag - take difference between AUCs
    
end



%% plot figures if asked to

if opt.verbose
    
    % FIGURE 2 -  fH41 ******
    % --------------------
    
    % plot the fitted line
    for roi_idx = 1:numRoi  % for every roi
        curRoi = opt.rois{roi_idx};
        
        figName41 = sprintf('%s vs eccentricity, roi: %s',opt.yAxis,curRoi);
        fH41 = figure(41); set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName41,'PaperPositionMode', 'auto'); clf;
        
        y_params_AverageToFit = squeeze(y_params_Average(:,:,:,roi_idx));
        x_params_AverageToFit = squeeze(x_params_Average(:,:,:,roi_idx));
        
        y_params_AverageToFit_std = squeeze(y_params_Average_std(:,:,:,roi_idx));
        
        
        for cond_idx = 1:numCond % for every condition
            curCond = opt.conditions{cond_idx};
            
            switch curCond
                case 'SZ-VH'
                    subjects = opt.subjects.ptH;
                case 'SZ-nVH'
                    subjects = opt.subjects.ptNH;
                case 'HC'
                    subjects = opt.subjects.HC;
            end
            numSub = length(subjects);
            
            
            y_params_AverageToFit_sterr = y_params_AverageToFit_std(:,cond_idx)./ sqrt(numSub);
            
            xVal =  xFit;
            plot(xVal,params_AverageFit.fit{cond_idx,roi_idx},'color',color_map(cond_idx,:),'LineWidth',6); hold on;
            errorbar(x_params_AverageToFit(:,cond_idx), y_params_AverageToFit(:,cond_idx),y_params_AverageToFit_sterr,'.','color',color_map(cond_idx,:),...
                'MarkerFaceColor','b','MarkerSize',25,'LineStyle','none','HandleVisibility','off','LineWidth',2,'CapSize',10); hold on;
            
            hold on;
        end
        xlim(opt.xaxislim);
        ylim(opt.yaxislim);
        xlabel('Eccentricity (degrees)');
        ylabel(sprintf('%s',opt.yAxis));
        set(gca,'FontUnits','centimeters','FontSize',2,'TickDir','out','LineWidth',5); box off;
        legend(opt.conditions,'Location','northwest');
        
        if opt.saveFig
            saveDir = fullfile(dirPth.saveDirMSFig,'figure4',sprintf('figure4m_%s',opt.plotType));
            if ~exist(saveDir,'dir')
                mkdir(saveDir);
            end
            
            % figure 41
            figName = figName41;
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_Avefit_%s_%d'],curRoi,numSub);
            print(fH41, fullfile(saveDir,fullFilename), '-dpng');
            
            saveDirMS = fullfile(dirPth.saveDirMSFigures,'figure2',opt.plotType);
            if ~exist(saveDirMS,'dir')
                mkdir(saveDirMS);
            end
            
            print(fH41, fullfile(saveDirMS,fullFilename), '-depsc2');
        end
        
        
    end
    
    if opt.detailedPlot
        % Plot central value difference & area under curve difference
        fH51    = figure(51);clf;
        figName51 = sprintf('pRF size at central eccentricity difference');
        set(gcf,'position',[407,103,1374,804],'Name',figName51);
        bar([params_AverageDiff.CEN.HCPtH;params_AverageDiff.CEN.HCPtNH;params_AverageDiff.CEN.PtNHPtH]'); % columns - rois
        xlim(opt.xaxislimCen);
        ylim(opt.yaxislimCen);
        xlabel('Visual field maps');
        ylabel('Normalized central value difference (%)');
        set(gca,'XTickLabel',opt.rois);
        set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;
        lg = {'HC - PtH'; 'HC - PtNH';'PtH - PtNH'};
        legend(lg);
        
        fH52    = figure(52);clf;
        figName52 = sprintf('Area under curve difference');
        set(gcf,'position',[407,103,1374,804],'Name',figName52);
        bar([params_AverageDiff.AUC.HCPtH;params_AverageDiff.AUC.HCPtNH;params_AverageDiff.AUC.PtNHPtH]'); % columns - rois
        xlim(opt.xaxislimCen);
        ylim(opt.yaxislimCen);
        xlabel('Visual field maps');
        ylabel('Normalized area under curve difference (%)');
        set(gca,'XTickLabel',opt.rois);
        set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;
        legend(lg);
        
        if opt.saveFig
            saveDir = fullfile(dirPth.saveDirMSFig,'figure5',sprintf('figure5m_%s',opt.plotType));
            if ~exist(saveDir,'dir')
                mkdir(saveDir);
            end
            % figure 51
            figName = figName51;
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_cenDiff_%s_%d'],curRoi,numSub);
            print(fH51, fullfile(saveDir,fullFilename), '-dpng');
            
            % figure 51
            figName = figName52;
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_aucDiff_%s_%d'],curRoi,numSub);
            print(fH52, fullfile(saveDir,fullFilename), '-dpng');
        end
        
        
        % Plot central value &  area under curve
        fH511    = figure(511);clf;
        figName511 = sprintf('central value');
        set(gcf,'position',[407,103,1374,804],'Name',figName511);
        bar(params_AverageCen'); % columns - rois
        xlim(opt.xaxislimCen);
        ylim(opt.yaxislimCen);
        xlabel('Visual field maps');
        ylabel('pRF size at a central eccentricity (degrees)');
        set(gca,'XTickLabel',opt.rois);
        set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;
        lg = {'PtH'; 'PtNH';'HC'};
        legend(lg);
        
        fH521    = figure(521);clf;
        figName521 = sprintf('Area under curve');
        set(gcf,'position',[407,103,1374,804],'Name',figName521);
        bar(params_AverageAuc'); % columns - rois
        xlim(opt.xaxislimCen);
        ylim(opt.yaxislimCen);
        xlabel('Visual field maps');
        ylabel('Area under curve');
        set(gca,'XTickLabel',opt.rois);
        set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;
        legend(lg);
        
        if opt.saveFig
            saveDir = fullfile(dirPth.saveDirMSFig,'figure5',sprintf('figure5m_%s',opt.plotType));
            if ~exist(saveDir,'dir')
                mkdir(saveDir);
            end
            % figure 51
            figName = figName511;
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_cen_%s_%d'],curRoi,numSub);
            print(fH511, fullfile(saveDir,fullFilename), '-dpng');
            
            % figure 51
            figName = figName521;
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_auc_%s_%d'],curRoi,numSub);
            print(fH521, fullfile(saveDir,fullFilename), '-dpng');
        end
        
    end
end
end