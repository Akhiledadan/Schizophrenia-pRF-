function makeFigure5A(params_comp,dirPth,opt)


% compute the average auc and central values
auc_average = squeeze(nanmean(params_comp.auc,2)); % #cond x 1 x #roi
auc_std     = squeeze(nanstd(params_comp.auc,[],2));
n           = [length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]';
auc_sterr   = auc_std ./  sqrt(n);

cen_average = squeeze(nanmean(params_comp.cen,2)); % #cond x 1 x #roi
cen_std     = squeeze(nanstd(params_comp.cen,[],2));
n           = [length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]';
cen_sterr   = cen_std ./  sqrt(n);


fH5211    = figure(5211);clf;
figName5211 = sprintf('Area under curve');
set(gcf,'position',[66,1,1855,1001],'Name',figName5211,'PaperPositionMode', 'auto');
b = bar(auc_average'); % columns - rois
b(1).FaceColor = [0.5 1 0.5];
b(2).FaceColor = [0.5 0.5 1];
b(3).FaceColor = [1 0.5 0.5];
hold on;
h = errorbar_group(auc_average',auc_sterr'); hold on;  
h(1).FaceColor = [0.5 1 0.5];
h(2).FaceColor = [0.5 0.5 1];
h(3).FaceColor = [1 0.5 0.5];

h(1).LineWidth = 2;
h(2).LineWidth = 2;
h(3).LineWidth = 2;
lg = opt.conditions;
legend(lg,'Location','northwest');
xlim(opt.xaxislimCen);
ylim(opt.yaxislimCen);
xlabel('Visual field maps');
ylabel('Area under curve');
set(gca,'XTickLabel',opt.rois);
set(gca,'FontUnits','centimeters','FontSize',1.1,'TickDir','out','LineWidth',3); box off;

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure5',sprintf('figure5m_%s',opt.plotType));
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    % figure 5211
    figName = figName5211;
    figName(regexp(figName,' ')) = '_';
    filename                     = figName;
    fullFilename                 = sprintf([filename,'_auc_average_ind']);
    print(fH5211, fullfile(saveDir,fullFilename), '-dpng');

end

%% central value
%%%-------------
% FIGURE 3 *****
%---------------
fH5212    = figure(5212);clf;
figName5212 = sprintf('Central value');
set(gcf,'position',[66,1,1855,1001],'Name',figName5212,'PaperPositionMode', 'auto');
b = bar(cen_average'); % columns - rois
b(1).FaceColor = [0.5 1 0.5];
b(2).FaceColor = [0.5 0.5 1];
b(3).FaceColor = [1 0.5 0.5];
hold on;
h = errorbar_group(cen_average',cen_sterr'); hold on;  
h(1).FaceColor = [0.5 1 0.5];
h(2).FaceColor = [0.5 0.5 1];
h(3).FaceColor = [1 0.5 0.5];

h(1).LineWidth = 2;
h(2).LineWidth = 2;
h(3).LineWidth = 2;
lg = opt.conditions;
legend(lg,'Location','northwest');
xlim(opt.xaxislimCen);
ylim(opt.yaxislimCen);
xlabel('Visual field maps');
ylabel(opt.yAxis);
set(gca,'XTickLabel',opt.rois);
set(gca,'FontUnits','centimeters', 'FontSize', 1.5,'TickDir','out','LineWidth',3); box off;

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure5',sprintf('figure5m_%s',opt.plotType));
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    % figure 5211
    figName = figName5212;
    figName(regexp(figName,' ')) = '_';
    filename                     = figName;
    fullFilename                 = sprintf([filename,'_cen_average_ind']);
    print(fH5212, fullfile(saveDir,fullFilename), '-dpng');
    
    
    saveDirMS = fullfile(dirPth.saveDirMSFigures,'figure3',opt.plotType);
    if ~exist(saveDirMS,'dir')
        mkdir(saveDirMS);
    end
    print(fH5212, fullfile(saveDirMS,fullFilename), '-depsc2');
end



end