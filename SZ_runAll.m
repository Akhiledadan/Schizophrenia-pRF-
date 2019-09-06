% Script to generate figures for 3 conditions

clear all; close all;
% 1. sigma vs eccentricity
modelType = '2DGaussian';
plotType = 'Ecc_Sig';
opt = getOpts('modelType',modelType,'plotType',plotType,'verbose',1);
SZ_pRFAnalysis(opt);
close all;

% 2. fwhm vs eccentricity (DoGs)
modelType = 'DoGs';
plotType = 'Ecc_Sig_fwhm_DoGs';
opt = getOpts('modelType',modelType,'plotType',plotType);
SZ_pRFAnalysis(opt);
close all;

% 3. surround size vs eccentricity (DoGs)
modelType = 'DoGs';
plotType = 'Ecc_SurSize_DoGs';
opt = getOpts('modelType',modelType,'plotType',plotType);
SZ_pRFAnalysis(opt);
close all;

% 3. surround depth vs eccentricity (DoGs)
modelType = 'DoGs';
plotType = 'Ecc_SurDepth_DoGs';
opt = getOpts('modelType',modelType,'plotType',plotType);
SZ_pRFAnalysis(opt);
close all;