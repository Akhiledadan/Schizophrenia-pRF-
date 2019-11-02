function [CEN,CEN_diff,CEN_diff_rel,CEN_diffBootstrap,CEN_upper,CEN_lower] = SZ_CEN(b,opt)
% NP_CEN -  to calculate the central values from the pRF size vs
% eccentricity fit and take the differece between two groups

if isempty(opt.cenEcc)
   fprintf('Please provide a central ecccentricity');
   return;
end

CEN=[];
if ~opt.cenDifference
    CEN = central(b,opt.cenEcc);
end

% difference
CEN_diff     = [];
CEN_diff_rel = [];
if opt.cenDifference
    CEN1 = central(b(:,1),opt.cenEcc);
    CEN2 = central(b(:,2),opt.cenEcc);
    
    CEN_diff   = CEN1-CEN2;

    % relative difference - to account for the increase in pRF size with visual
    % areas and the resulting decrease in precision in percentage
    CEN_diff_rel= (CEN_diff./(mean([CEN1,CEN2])))*100 ;
end

% bootstrap the central difference to get the confidence interval
CEN_diffBootstrap = [];
CEN_upper         = [];
CEN_lower         = [];


end

function cenVal_1 = central(b,x)
% for natural condition
M_1           = b(1);
C_1           = b(2);

cenVal_1      =  M_1 .* x + C_1;

end