function params_comp = SZ_compareSig1Sig2(modelData,opt,dirPth)
% SZ_compareSig1Sig2 - compute sig1/sig for all voxels for every subject
% and compute the average for each of the groups.

conditions = opt.conditions;
numCond    = length(conditions);
numRoi     = length(opt.rois);

ptH_sigmaRatio  = [];
ptNH_sigmaRatio = [];
HC_sigmaRatio = [];

for cond_idx = 1:numCond
    
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
    
    for sub_idx = 1:numSub
        for roi_idx = 1:numRoi
            sig2 = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma2;
            mask = sig2 > 0.01;% when DoGs are compared against 2D gaussian, sigma2 values are set to be very small if VE(2DG) > VE(DoG)
            
            sigma1 = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma(mask);
            sigma2 = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma2(mask);
            
            sigmaRatio = sigma2./sigma1;
            
            params_comp.y_comp{cond_idx,sub_idx,roi_idx} = sigmaRatio;
            params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp(mask);
            params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc(mask);
            
            if cond_idx == 1
                ptH_sigmaRatio  = [ptH_sigmaRatio params_comp.y_comp{cond_idx,sub_idx,roi_idx}];
            elseif cond_idx == 2
                ptNH_sigmaRatio = [ptNH_sigmaRatio params_comp.y_comp{cond_idx,sub_idx,roi_idx}];
            elseif cond_idx == 3
                HC_sigmaRatio   = [HC_sigmaRatio params_comp.y_comp{cond_idx,sub_idx,roi_idx}];
            end
        end
    end
end

if opt.plotSigRatio
    fh10000 = figure(10000); 
    figName10000 = sprintf('Central value');
    set(gcf,'position',[407,103,1374,804],'Name',figName10000);
    
    ax1 = subplot(1,3,1);
    histogram(ptH_sigmaRatio,100,'BinLimits',[0 prctile(ptH_sigmaRatio,95)]);
    xlabel(opt.yAxis); ylabel('frequency');
    
    ax2 = subplot(1,3,2);
    histogram(ptNH_sigmaRatio,100,'BinLimits',[0 prctile(ptNH_sigmaRatio,95)]);
    xlabel(opt.yAxis); ylabel('frequency');
    
    ax3 = subplot(1,3,3);
    histogram(HC_sigmaRatio,100,'BinLimits',[0 prctile(HC_sigmaRatio,95)]);
    xlabel(opt.yAxis); ylabel('frequency');
    
    
    if opt.saveFig
        saveDir = fullfile(dirPth.saveDirMSFig,'figure6',sprintf('figure6_%s',opt.plotType));
        if ~exist(saveDir,'dir')
            mkdir(saveDir);
        end
        
        % figure 5211
        figName = figName10000;
        figName(regexp(figName,' ')) = '_';
        filename                     = figName;
        fullFilename                 = sprintf([filename,'_distribution']);
        print(fh10000, fullfile(saveDir,fullFilename), '-dpng');
    end

    
end



end