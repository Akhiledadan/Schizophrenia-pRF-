function data = SZ_getPredictedResponse(data,opt,modelData)
% SZ_getPredictedResponse - Extract raw time series from the model file and
% generate the plot for Schizophrenic (with and without hallucination) and control populations
%
% input - dirPth : Path to the directory containing model files
%       - opt    : different options
%
% 04/10/2019: written by Akhil Edadan (a.edadan@uu.nl)

conditions = opt.conditions;
numCond = length(conditions);

rois = opt.rois;
numRoi = length(rois);


numSubMax = max([length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]);

data.predictions_rois    = cell(numCond,numSubMax,numRoi);
data.timeSeries_rois_thr = cell(numCond,numSubMax,numRoi);

for cond_idx = 1:numCond
    curCond = opt.conditions{cond_idx};
    fprintf('\n %s...',curCond);
    
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
        fprintf('%s...',curSub);
        
        for roi_idx = 1:numRoi
            curRoi      = opt.rois{roi_idx};
            
            roiThrIdx   = modelData.roi_index{cond_idx,sub_idx,roi_idx};
            
            
            % save the timeseries and coordinates thresholded using
            % varaince explained and eccentricity
            data.timeSeries_rois_thr{cond_idx,sub_idx,roi_idx}.tSeries                 = data.timeSeries_rois{cond_idx,sub_idx,roi_idx}.tSeries(:,roiThrIdx);
            data.timeSeries_rois_thr{cond_idx,sub_idx,roi_idx}.coords                  = data.timeSeries_rois{cond_idx,sub_idx,roi_idx}.coords(:,roiThrIdx);
            data.timeSeries_rois_thr{cond_idx,sub_idx,roi_idx}.params.roi.coords       = data.timeSeries_rois{cond_idx,sub_idx,roi_idx}.params.roi.coords(:,roiThrIdx);            
            data.timeSeries_rois_thr{cond_idx,sub_idx,roi_idx}.params.roi.coordsIndex  = data.timeSeries_rois{cond_idx,sub_idx,roi_idx}.params.roi.coordsIndex(roiThrIdx,:);            
            
            params    = data.timeSeries_rois{cond_idx,sub_idx,roi_idx}.params;
            model     = modelData.modelInfo{cond_idx,sub_idx,roi_idx};
            pred      = SZ_computePredictedResponse(params,model,opt,data.timeSeries_rois{cond_idx,sub_idx,roi_idx}); % prediction = (stim*pRFModel)xBeta
            
            data.predictions_rois{cond_idx,sub_idx,roi_idx} = pred;
            data.predictions_rois_thr{cond_idx,sub_idx,roi_idx} = data.predictions_rois{cond_idx,sub_idx,roi_idx}(roiThrIdx,:);
            
            
        end
    end
    
end

end