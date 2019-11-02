function SZ_pRFAnalysis(opt)
% SZ_pRFAnalysis - Plots Sigma/fWHM(DoGs)/Surround size(DoGs) vs eccentricity for the pRF fits to compare
% Schizophrenia patients with (ptwH+) and without (ptwH-) hallucinations
% and healthy controls (HC)
%
% Input - modeling results for nat and ph scr
%       - ROIs
%       - main_dir : mrVista session directory (where mrSESSION.mat file is located)
%       - save_results : path of folder to save the results
%       - save_plots : 1- save figures 0 - don't save
% 31/10/2018: [A.E] wrote it

%%
% Go to the root path where a simlink called data is created, containing
% the data
dirPth = SZ_loadPaths;

cd(SZ_rootPath);

% set options
%opt = getOpts('modelType','2DGaussian','plotType','Ecc_Sig');

fprintf('Model used: %s \n plotting: %s \n',opt.modelType, opt.plotType);

% for 2D Guassian model - use               opt = getOpts('modelType','2DGaussian'); for
%     Difference of gaussians - use         opt = getOpts('modelType','DoGs');
%
% To plot sigma vs ecc - use                opt = getOpts('plotType','Ecc_Sig');
%     sig vs fwhm DoGs                      opt = getOpts('plotType','Ecc_Sig_fwhm_DoGs');
%     sig vs surround size DoGs             opt = getOpts('plotType','Ecc_SurSize_DoGs');

%% Initializing required variables

fprintf('\n(%s)>>', mfilename);

% Make the directory to save results
cur_time = datestr(now);
cur_time(cur_time == ' ' | cur_time == ':' | cur_time == '-') = '_';


%% Extract the pRF parameters for individual subject, condition and ROI

if opt.extractPrfParams
    modelData = SZ_getModelParams(opt,dirPth);
else
    dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
    load(fullfile(dirPth.saveDirPrfParams,'prfParams.mat'));
end


%%
% Get the time series
if opt.getTimeSeries
    % Figure2: To make the time series figure
    data = SZ_getTimeSeries(dirPth,opt); % data: #condition x #subjects x #rois (2nd dimension contains fields with maximum number of subjects of all conditions)
    
    if opt.getPredictedResponse
       data = SZ_getPredictedResponse(data,opt,modelData); 
    end
    
    if opt.verbose
        if opt.plotTimeSeries
            % Plot original and predicted timeSeries: Figure 1
            SZ_makeFigure2(data,modelData,opt,dirPth);
        end
    end
    
    
end

%% Basic exploratory analysis

if opt.expAnalysis
    % Distribution of parameters to compare
    SZ_expAnalysis(modelData,opt);
    
    % To remove subjects who are outliers.
    exclusionCriteria = SZ_pRFsizeEcc(modelData,opt,dirPth);
   
    if opt.excludeSub
        opt = SZ_excludeSub(opt,exclusionCriteria);
    end
    
end


%% Comparison of different pRF parameters

dirPth.saveDirResTime = cur_time;
switch opt.analysis
    case 'subave_Ave'
        SZ_pA_subAveAve(modelData,opt,dirPth); % Average individual subjects data first and then average the averaged value from the subjects
        
    case 'alltog'
        SZ_pA_allTog(modelData,opt,dirPth); % Take a grand average of all the subjects put together
end

fprintf('\n(%s): Done!', mfilename)

end

