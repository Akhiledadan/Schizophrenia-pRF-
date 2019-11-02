function exclusionCriteria = SZ_pRFsizeEcc(modelData,opt,dirPth)
% SZ_pA_subAveAVe - pRF comparison analysis (pA) for schizophrenia (SZ)
% project - 
% 
% pRF size values are averaged across subjects (average of ind
% subjects are calculated first and an average of the averages are computed
% thereafter. 
%
% inputs - modelData : variable containing modelling results 
%          opt       :    
%          dirPth    : 
% 
% 07/10/2019: written by Akhil Edadan (a.edadan@uu.nl)

opt.plotType = 'Ecc_Sig';
% identify prf parameters that has to be compared
[params_comp,opt] = SZ_prfParametersToCompare(modelData,opt);

% figures - raw, fit, bin, auc - for individual subjects
[params_comp,opt] = SZ_pA_plotParameters(params_comp,opt,dirPth);

% parameters to exclude subjects
exclusionCriteria.fit_slope       = params_comp.fit_slope; % # conditions x # Subjects x  # rois matrix (slope of the fitted line)
exclusionCriteria.auc             = params_comp.auc;       % # conditions x # Subjects x # rois matrix  (auc value)


end