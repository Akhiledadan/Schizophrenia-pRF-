% SZ_statsRunAll to perform statistical analysis on either the central
% values or area under curve values extracted from all subjects from the
% different subject groups.
%
% opt.compare can be chosed appropriately to decide if the schizophrenia
% patients should be considered together as one patient group, as two
% different groups when comparing with the healthy controls. Also, there is
% an option to compate only the patinet groups without the healthy
% controls. 
%
% opt.roisToCompare can be set to define the ROIS to compare
%
% opt.paramToCompare can take as input either 'central' or 'AUC'
%
% curParam is used to define the parameter that is compared
% 
% modelType is used to define the tye of model (either 1D gaussian or Difference of gaussians)
%
% For different options check SZ_getOpts.m function

clear all;
opt.compare = 'patientsTogether';
%opt.compare = 'patientsSeparate';
%opt.compare = 'patientsOnly';

opt.roisToCompare = 'V1234';
%opt.roisToCompare = 'V3';

opt.paramToCompare = 'central';

%%
curParam = 'sigma_1G';
modelType = '2DGaussian';
plotType = 'Ecc_Sig';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)

% SZ_repeatedMeasuresAnova(curParam,opt);
% SZ_unpairedTtest(curParam,opt);

% ANOVA for every ROI separately
% SZ_oneWayAnova(curParam,opt);
SZ_NWayAnova(curParam,opt);

%%
curParam = 'FWHM';
modelType = 'DoGs';
plotType = 'Ecc_Sig_fwhm_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
% SZ_repeatedMeasuresAnova(curParam,opt)
% SZ_unpairedTtest(curParam,opt);

% ANOVA for every ROI separately
% SZ_oneWayAnova(curParam,opt);
SZ_NWayAnova(curParam,opt);
 
%%
curParam = 'surroundSize';
modelType = 'DoGs';
plotType = 'Ecc_SurSize_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
%SZ_repeatedMeasuresAnova(curParam,opt)

% To compare between the two patient groups for every ROI. Perform 4
% different t-test for V1, V2, V3 and V4 - and correct for multiple
% comparison by - 
% SZ_unpairedTtest(curParam,opt);

% ANOVA for every ROI separately
% SZ_oneWayAnova(curParam,opt); 
 SZ_NWayAnova(curParam,opt);
 
%%

curParam = 'suppressionIndex';
modelType = 'DoGs';
plotType = 'Ecc_SuppressionIndex_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
% SZ_repeatedMeasuresAnova(curParam,opt);
% SZ_unpairedTtest(curParam,opt);

% ANOVA for every ROI separately
% SZ_oneWayAnova(curParam,opt); 
 SZ_NWayAnova(curParam,opt);
 
%%

curParam = 'sigma1';
modelType = 'DoGs';
plotType = 'Ecc_Sig1_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
% SZ_repeatedMeasuresAnova(curParam,opt)
% SZ_unpairedTtest(curParam,opt);

% ANOVA for every ROI separately
% SZ_oneWayAnova(curParam,opt);
SZ_NWayAnova(curParam,opt);

%%
curParam = 'sigma2';
modelType = 'DoGs';
plotType = 'Ecc_Sig2_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
%SZ_repeatedMeasuresAnova(curParam,opt)
%  SZ_unpairedTtest(curParam,opt);

% ANOVA for every ROI separately
% SZ_oneWayAnova(curParam,opt);
 SZ_NWayAnova(curParam,opt);
 


