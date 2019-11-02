function SZ_makeFigure2(data,modelData,opt,dirPth)

TR               = 1.5; % sampling rate at which fMRI data was acquired
numTRs           = size(data.timeSeries_rois_thr{1,1,1}.tSeries,1); % total number of sampling points
numTimePoints    = numTRs * TR;
time             = linspace(1,numTimePoints,numTRs);

conditions       = opt.conditions;% 3 conditions (ptH, ptNH, HC)
numCond          = length(conditions);

for cond_idx = 1:numCond % for 3 conditions (ptH, ptNH, HC)
    
    curCond = conditions{cond_idx};
    fprintf('%s...',curCond);
    
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
        
        curSub      = subjects{sub_idx};
        numRoi      = length(opt.rois);
        for roi_idx = 1:numRoi
            curRoi = opt.rois{roi_idx};
            % Plot the fit line
            figName = sprintf('Original and predicted timeSeries for roi %s',curRoi);
            
            % find the voxels with maximum variance explained in both conditions
            % and plot those
            thr_ve                = max(modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp); 
            vox_idx_toPlot        = find(modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp ==  thr_ve);
            numVox                = length(vox_idx_toPlot);
            %fprintf('Plotting %d figures',numVox);


            for vox_idx = 1:numVox
                cur_vox = vox_idx_toPlot(vox_idx);
                
                fH1 = figure(1);clf;
                set(gcf,'position',[407,103,1374,804],'Name',figName);
                plot(time, data.timeSeries_rois_thr{cond_idx,sub_idx,roi_idx}.tSeries(:,cur_vox),'o--','color',[0 0 0],'LineWidth',4,'markerSize',7);
                hold on;                
                
                plot(time, data.predictions_rois_thr{cond_idx,sub_idx,roi_idx}(cur_vox,:),'color',[0.5 0.5 1],'LineWidth',4);
                
                xlim(opt.xLimTs);
                ylim(opt.yLimTs);
                legend({'Measured','Predicted'},'location','southeast');
                
                %--- texts in the plot
                x_cond                = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.x(cur_vox);
                y_cond                = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.y(cur_vox);
                ve_cond               = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp(cur_vox);
                s_cond                = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma(cur_vox);
                b_cond                = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.beta(cur_vox); 
                coords_cond           = data.timeSeries_rois_thr{cond_idx,sub_idx,roi_idx}.params.roi.coords(:,cur_vox); 
                %---------------------
                
                txt_inPlot = sprintf('coords: [%d,%d,%d] \n %s    x: %f, y: %f \n       ve : %f, sigma: %f, beta: %f',coords_cond(1),coords_cond(2),coords_cond(3), curCond, x_cond,y_cond,ve_cond,s_cond,b_cond );
                
                text(0.2,0.2,txt_inPlot,'Color',[0.2 0.2 0.2],'FontSize',15,'Units','normalized');
                
                xlabel('time (sec)');
                ylabel('% BOLD response');
                set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;
                
                if opt.saveFigTseries
                    saveDir = fullfile(dirPth.saveDirMSFig,'figure2',sprintf('figure2_%s_%s',curSub,opt.plotType));
                    if ~exist(saveDir,'dir')
                        mkdir(saveDir);
                    end
                    
                    figName(regexp(figName,' ')) = '_';
                    filename                     = figName;
                    fullFilename                 = sprintf([filename,'_ts_%s_%d'],curSub,vox_idx_toPlot(vox_idx));
                    print(fH1, fullfile(saveDir,fullFilename), '-dpng');
                end
            end
        end 
    end
end

end