function opt = SZ_excludeSub(opt,exclusionCriteria)
% SZ_excludeSub(opt,exclusionCriteria) - function to exclude subjects based
% on the slope and area under curve of pRF size vs eccentricity fitted line
% Criteria for exclusion: (1) slope for any one of the visual area < 0 
%                       : (2) area under curve for V1 > V3
% 
% 15/10/2019: written by Akhil Edadan (a.edadan@uu.nl)


slope = exclusionCriteria.fit_slope;

conditions = opt.conditions;
numCond    = length(conditions);
numSubMax =  max([length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]);
numRoi = length(opt.rois);
% sort visual areas according to auc value and save the order
visualAreaOrder = nan(numCond,numSubMax,numRoi);

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
        
        auc_roi                         = squeeze(exclusionCriteria.auc(cond_idx,sub_idx,:)); 
        [auc_roi_sort,auc_roi_sort_idx] = sort(auc_roi); 
        
        visualAreaOrder(cond_idx,sub_idx,:) = auc_roi_sort_idx;
               
    end
end

sub_count = 1;
for cond_idx = 1:size(slope,1)
    
    slopeMask_tmp      = squeeze(slope(cond_idx,:,:));
    visualAreaMask_tmp = squeeze(visualAreaOrder(cond_idx,:,:));
    
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
    sub_exclude = [];
    
    for sub_idx = 1:numSub
        curSub = subjects{sub_idx};
        
        if any(slopeMask_tmp(sub_idx,:)<0) || visualAreaMask_tmp(sub_idx,1) > visualAreaMask_tmp(sub_idx,3)
           
            sub_exclude{sub_count} = curSub;   
            fprintf('\n(%s): excluding subject: %s \n',mfilename,curSub);
            sub_count = sub_count+1;
        end
    end
     opt.subjectsToExclude.(curCond) = [sub_exclude];
end



end