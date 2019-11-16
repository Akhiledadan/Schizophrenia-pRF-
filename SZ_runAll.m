% Script to run the pRF analysis after running pRF models (2D Gaussian and DoG) 
% Models can be run using the script SZ_mrV.m

clear all; close all;
% 1. sigma vs eccentricity
modelType = '2DGaussian';
plotType = 'Ecc_Sig';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'detailedPlot',0,'getTimeSeries',0,'getPredictedResponse',0,'recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;

%%

% 2. fwhm vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_Sig_fwhm_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'detailedPlot',0,'getTimeSeries',0,'getPredictedResponse',0,'recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);

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


% 3. suppression index vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'Ecc_SuppressionIndex_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'getTimeSeries',0,'detailedPlot',0','recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;

% 3. sigma ratio vs eccentricity (DoGs)
clear all; close all;
modelType = 'DoGs';
plotType = 'sigmaRatio_DoGs';
opt = SZ_getOpts('modelType',modelType,'plotType',plotType,'verbose',1,'extractPrfParams',0,'getTimeSeries',0,'detailedPlot',0','recomputeTimeSeries',0);
SZ_pRFAnalysis(opt);
close all;


%% To run the stats

SZ_statsRunAll;


