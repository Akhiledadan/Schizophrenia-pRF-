function SZ_expAnalysis(modelData,opt)

rois = opt.rois;
num_roi = length(rois);

conditions = opt.conditions;
numCond = length(conditions);

% Basic exploratory analysis
% Histogram distribution for individual subjects for individual conditions
if opt.verbose
    for roi_idx = 1:num_roi
        roi_comp = opt.rois{roi_idx};
        for cond_idx = 1:numCond
            cond_comp = conditions{cond_idx};
            figPoint_exp1 = figure('visible','off');titleall = sprintf('%s %s', roi_comp,cond_comp); title(titleall); set(gcf,'Name', titleall);
            
            cur_cond = conditions{cond_idx};
            switch cur_cond
                case 'ptH'
                    subjects = opt.subjects.ptH;
                case 'ptNH'
                    subjects = opt.subjects.ptNH;
                case 'HC'
                    subjects = opt.subjects.HC;
            end
            
            
            numSub = length(subjects);
            cols = 2;
            if rem(numSub,2)==0
                rows = numSub/cols;
            else
                rows = (numSub+1)/cols;
            end
            
            save_dir_exp = strcat(SZ_rootPath,'/data/plots/expAnalysis/');
            if ~exist(save_dir_exp,'dir')
                mkdir(save_dir_exp);
            end
            
            if strcmpi(opt.plotType,'Ecc_Sig')
                % Sigma
                figPoint_exp1 = figure(10000000);titleall = sprintf('%s %s', roi_comp,cond_comp); title(titleall); set(gcf,'Name', titleall);
                for sub_idx=1:numSub; subplot(rows,cols,sub_idx); hist(modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma); xlim([0 inf]); end
                saveas(figPoint_exp1,fullfile(save_dir_exp,strcat(sprintf('%s',regexprep(titleall,' ','_')),'sigma','.png')));
            end
            
            if strcmpi(opt.plotType,'Ecc_Sig_fwhm_DoGs')
                % full width half max of the positive gaussian
                figPoint_exp2 = figure(10000000);titleall = sprintf('%s %s', roi_comp,cond_comp); title(titleall); set(gcf,'Name', titleall);
                for sub_idx=1:numSub; subplot(rows,cols,sub_idx); hist(modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_fwhmax); xlim([0 inf]); end
                saveas(figPoint_exp2,fullfile(save_dir_exp,strcat(sprintf('%s',regexprep(titleall,' ','_')),'fwhm','.png')));
            end
            
            if strcmpi(opt.plotType,'Ecc_SurSize_DoGs')
                % surround size (distance between the negative peak of the surround)
                figPoint_exp3 = figure(10000000);titleall = sprintf('%s %s', roi_comp,cond_comp); title(titleall); set(gcf,'Name', titleall);
                for sub_idx=1:numSub; subplot(rows,cols,sub_idx); hist(modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_surroundSize); xlim([0 inf]); end
                saveas(figPoint_exp3,fullfile(save_dir_exp,strcat(sprintf('%s',regexprep(titleall,' ','_')),'SurSize','.png')));
            end
            
        end
        
    end
end