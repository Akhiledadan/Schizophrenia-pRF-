% Main script to run the pRF analysis after running pRF models (2D Gaussian and DoG) using the script SZ_mrV.m

% Run SZ_runAll.m from folder containing the folder named "mrvista" which in turn
% contain the folders with subject names and contain vistasession for that subject.  

% Use SZ_getOpts.m function to set different options such as modelType,
% plotType. 

% SZ_pRFAnalysis.m will extract the pRF model parameters as set by the
% plot_Type and save the relevant figures. 

% SZ_statsRunAll.m can be used to run the statistical analysis (an n-way anova for every ROI separately). 

%%
% 1. sigma vs eccentricity
modelType = '2DGaussian';
plotType = 'Ecc_Sig';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'detailedPlot',0,'getTimeSeries',1,'getPredictedResponse',1,'recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;
%%
% 2. fwhm vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_Sig_fwhm_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'detailedPlot',0,'getTimeSeries',0,'getPredictedResponse',0,'recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
%%
% 3. surround size vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_SurSize_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'detailedPlot',0,'getTimeSeries',0,'recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;


% 3. sigma2 vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_Sig2_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'detailedPlot',0,'getTimeSeries',0,'recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;

%%
% 3. sigma1 vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_Sig1_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'getTimeSeries',0,'detailedPlot',0','recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;
%%
% 3. suppression index vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_SuppressionIndex_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'getTimeSeries',0,'detailedPlot',0','recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;
%%
% 3. sigma ratio vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'sigmaRatio_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'getTimeSeries',0,'detailedPlot',0','recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;


%% To run the stats

SZ_statsRunAll;


