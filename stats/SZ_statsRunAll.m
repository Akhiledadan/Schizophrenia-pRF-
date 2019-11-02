clear all;
%opt.compare = 'patientsTogether';
opt.compare = 'patientsSeparate';
%opt.compare = 'patientsOnly'

opt.roisToCompare = 'V1234';
%opt.roisToCompare = 'V3';

opt.paramToCompare = 'central';

%%

curParam = 'sigma_1G';
modelType = '2DGaussian';
plotType = 'Ecc_Sig';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
SZ_repeatedMeasuresAnova(curParam,opt);
SZ_unpairedTtest(curParam,opt);

%%
curParam = 'FWHM';
modelType = 'DoGs';
plotType = 'Ecc_Sig_fwhm_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
SZ_repeatedMeasuresAnova(curParam,opt)
SZ_unpairedTtest(curParam,opt);

%%

curParam = 'sigma1';
modelType = 'DoGs';
plotType = 'Ecc_Sig1_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
SZ_repeatedMeasuresAnova(curParam,opt)
SZ_unpairedTtest(curParam,opt);

%%
curParam = 'sigma2';
modelType = 'DoGs';
plotType = 'Ecc_Sig2_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
SZ_repeatedMeasuresAnova(curParam,opt)
SZ_unpairedTtest(curParam,opt);

%%
curParam = 'surroundSize';
modelType = 'DoGs';
plotType = 'Ecc_SurSize_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
SZ_repeatedMeasuresAnova(curParam,opt)
SZ_unpairedTtest(curParam,opt);

%%

curParam = 'suppressionIndex';
modelType = 'DoGs';
plotType = 'Ecc_SuppressionIndex_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'compare',opt.compare,'roisToCompare',opt.roisToCompare,'paramToCompare',opt.paramToCompare);
fprintf('%s',curParam)
SZ_repeatedMeasuresAnova(curParam,opt);
SZ_unpairedTtest(curParam,opt);