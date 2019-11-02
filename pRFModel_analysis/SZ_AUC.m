function [AUC,AUC_diff,AUC_diff_rel,AUC_diffBootstrap,AUC_upper,AUC_lower] = SZ_AUC(x_param,y_param,opt)
% AUCootstrap the mean values from all participants in each group and
% calculate the AUC 
% 
% x_param and y_params - matrices with rows = number of data points
%                        (eccentrcity bins) and cols = number of groups to
%                        take the difference
%                   

% by default calculate only single auc
if isempty(opt.aucDifference)
    opt.aucDifference = 0;
end

% caluculate the area under the curve
AUC = [];
if ~opt.aucDifference
    AUC = trapz(x_param,y_param);
end

% difference between auc for different groups
AUC_diff = [];
AUC_diff_rel = [];
if opt.aucDifference
 
    AUC1 = trapz(x_param(:,1),y_param(:,1));
    AUC2 = trapz(x_param(:,2),y_param(:,2));
    
    AUC_diff = AUC1 - AUC2;    
    % relative difference - to account for the increase in pRF size with visual
    % areas and the resulting decrease in precision in percentage
    AUC_diff_rel= (AUC_diff./(mean([AUC1,AUC2])))*100 ;
    
end

AUC_diffBootstrap = [];
AUC_upper         = [];
AUC_lower         = [];
if opt.aucBootstrap
    w       = ones(size(y_param));

    AUC1 = bootstrp(1000,@(x) SZ_areaUnderCurve(x,x_param(:,1),y_param(:,1),w(:,1)),(1:size(x_param(:,1),1)));
    %  figure(8),
    AUC2 = bootstrp(1000,@(x) SZ_areaUnderCurve(x,x_param(:,2),y_param(:,2),w(:,2)),(1:size(x_param(:,2),1)));
    
    AUC_diffBootstrap = AUC1 - AUC2;
    % Upper and lower AUCounds (calculated as the 2.5 percentile and 97.5 percentile of the values)
    pct1 = 100*0.05/2;
    pct2 = 100-pct1;
    AUC_lower = prctile(AUC_diffBootstrap,pct1);
    AUC_upper = prctile(AUC_diffBootstrap,pct2);
    
    % Select the values within 2.5 and 97.25 percentile for calculating
    % the mean
    keep1 = AUC_diff(:,1)>AUC_lower(1) &  AUC_diff(:,1)<AUC_upper(1);
    keep = keep1;
    
    % 100 values for plotting the upper (97.5) and lower AUCounds (2.5) of the
    % AUCootstrapped data
    AUC_y = median(AUC_diffBootstrap(keep,:),1);
    AUC_upper = max(AUC_diffBootstrap(keep,:),[],1);
    AUC_lower = min(AUC_diffBootstrap(keep,:),[],1);
end



end