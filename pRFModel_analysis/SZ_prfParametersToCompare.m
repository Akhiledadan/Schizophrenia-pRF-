function [params_comp,opt] = SZ_prfParametersToCompare(modelData,opt,dirPth)
% SZ_prfParametersToCompare - extract the prf parameters to compare

conditions = opt.conditions;
numCond    = length(conditions);
numRoi     = length(opt.rois);

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
    
    for sub_idx = 1:numSub % for the subjects within each condition (11,14,13 respectively)
        
        curSub = subjects{sub_idx};
        
        for roi_idx = 1:numRoi
            
            curRoi = opt.rois{roi_idx};
            
            % Choose the pRF parameters to compare
            switch opt.plotType
                
                case 'Ecc_Sig'
                    opt.yAxis = 'Sigma (degrees)';
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc;
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigmaFWHM;
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp;
                    
                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange   = xfit_range;
                    
                case 'Ecc_Sig_fwhm_DoGs'
                    
                    opt.yAxis = 'DoGs Full Width Half Max (degrees)';
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc;
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_fwhmax;
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp;
                    
                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                case 'Ecc_Sig1_DoGs'
                    
                    opt.yAxis = 'DoGs sigma1 (degrees)';
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc;
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma;
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp ;
                    
                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                    
                case 'Ecc_Sig2_DoGs'
                    
                    opt.yAxis = 'DoGs sigma2 (degrees)';
                    
                    sig2 = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma2;
                    mask = sig2 < 70 & sig2 > 0.01;
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc(mask);
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.sigma2(mask);
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp(mask);
                    
                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                case 'Ecc_Sig_fwhmin_DoGs'
                    
                    opt.yAxis = 'Full Width Half Min (degrees)';
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc;
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_fwhmin_first;
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp;
                    
                    % Axis limits for plotting
                    xaxislim = [0 5];
                    yaxislim = [0 5];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                case 'Ecc_SurSize_DoGs'
                    
                    opt.yAxis = 'DoGs Surround size (degrees)';
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc;
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_surroundSize;
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp;
                    
                    
                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                    
                case 'Ecc_SuppressionIndex_DoGs'
                    
                    opt.yAxis = 'DoGs suppression index';
                    
                    % find the top and bottom 5 percentile data
                    suppressionIndex = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_suppressionIndex;
                    
                    thresh = 'absoluteThreshold';
                    if strcmp(thresh,'top5Percentage')
                        totVoxels   = length(suppressionIndex);
                        fivePecent  = round(totVoxels * (5/100));
                        [sortVal, sortIndex] = sort(suppressionIndex,'descend');
                        % select the top 5 and bottom 5 percentage of voxels
                        % and remove
                        mask   = sortIndex(fivePecent:end-fivePecent);
                        
                    elseif strcmp(thresh,'absoluteThreshold')
                        mask =  suppressionIndex < 10;
                        
                    end
                    
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.DoGs_suppressionIndex(mask);
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc(mask);
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp(mask);
                    
                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                case 'sigmaRatio_DoGs'
                    
                    opt.yAxis = 'DoGs sigma ratio';
                    
                    params_comp = SZ_compareSig1Sig2(modelData,opt,dirPth);

                    % Axis limits for plotting
                    xaxislim = [0 10];
                    yaxislim = [0 inf];
                    
                    % x range values for fitting
                    xfit_range = opt.eccThr;
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xFitRange    = xfit_range;
                    
                    
                case 'Pol_Sig'
                    
                    opt.yAxis = 'Surround size (degrees)';
                    
                    params_comp.x_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.ecc;
                    params_comp.y_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.pol;
                    params_comp.ve_comp{cond_idx,sub_idx,roi_idx} = modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx}.varexp;
                    
                    % Axis limits for plotting
                    xaxislim = [0 2*pi];
                    yaxislim = [0 5];
                    
                    % x range values for fitting
                    Pol_Thr_low = 0;
                    Pol_Thr = 2*pi;
                    xfit_range = [Pol_Thr_low Pol_Thr];
                    
                    opt.xaxislim     = xaxislim;
                    opt.yaxislim     = yaxislim;
                    opt.xfit_range   = xfit_range;
                    
                case 'X_Sig'
                    
                    x_param_comp_1 = Cond_model{1,curRoi}{1}.x;
                    x_param_comp_2 = Cond_model{2,curRoi}{1}.x;
                    
                    y_param_comp_1 = Cond_model{1,curRoi}{1}.sigma;
                    y_param_comp_2 = Cond_model{2,curRoi}{1}.sigma;
                    
                    
                case 'Y_Sig'
                    x_param_comp_1 = Cond_model{1,curRoi}{1}.y;
                    x_param_comp_2 = Cond_model{2,curRoi}{1}.y;
                    
                    y_param_comp_1 = Cond_model{1,curRoi}{1}.sigma;
                    y_param_comp_2 = Cond_model{2,curRoi}{1}.sigma;
                    
            end
            
        end
    end
end



fprintf('\n DONE \n')
end