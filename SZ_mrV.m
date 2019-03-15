% Initializing the session and running mrVista 

% Contains all the codes for runnign pRF model
addpath(genpath('/Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_code/'))

%% 
mrInit;

% Clip 8 frames from the beginning
% Keep 128 frames after the clipped frames


%%
% Open inplane view
mrVista;

%% 
% Define stimulus parameters (images.mat and params.mat)

%% Doesn't work for some reasone XXXXXXXXXXX HAVE TO CHECK
  
roiFileName = 'test';
prfModels = {'one gaussian'};
searchType = 3;
outFileName = 'test_run';
INPLANE{1} = rmMain(INPLANE{1},roiFileName,searchType,'matFileName', outFileName,'model',prfModels);


%% 
% Alignment using rxALign (which is hopefully not a big pain)

rxAlign;

%% 
% Run the model on gray view for a test ROI

roiFileName = 'ROI1';
prfModels = {'one gaussian'};
searchType = 3;
outFileName = 'test_run';
rmMain(VOLUME{1},roiFileName,searchType,'matFileName', outFileName,'model',prfModels);


%% 
% Run the model on gray view on all voxels

%% 
% Define stimulus parameters (images.mat and params.mat)

hvol = initHiddenGray;
hvol = viewSet(hvol, 'curdt','averages');
hvol = rmLoadParameters(hvol);hvol=refreshScreen(hvol);

roiFileName = [];
prfModels = {'one gaussian'};
searchType = 3;
outFileName = 'SZ_2DGaussian';
rmMain(hvol,[],searchType,'matFileName', outFileName,'model',prfModels);


%% 
% Define stimulus parameters (images.mat and params.mat)

hvol = initHiddenGray;
hvol = viewSet(hvol, 'curdt','averages');
hvol = rmLoadParameters(hvol);hvol=refreshScreen(hvol);

roiFileName = [];
prfModels = {'one gaussian'};
searchType = 5;
outFileName = 'SZ_2DGaussian_hrf';
rmMain(hvol,[],searchType,'matFileName', outFileName,'model',prfModels);

%% Loading stimulus parameters initially (only has to be done once)

sub_num_all = [{'108'}];

tot_sub = length(sub_num_all);

for idx_sub = 1:tot_sub

sub_num = sub_num_all{idx_sub};
sub_dir = strcat('/Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_data/',sub_num,'/');

cd(sub_dir);

hvol = initHiddenGray;
hvol = viewSet(hvol, 'curdt','averages');
figpoint = rmEditStimParams(hvol);
uiwait(figpoint);


clearvars hvol figpoint sub_dir sub_num;

end


%% Running the model from terminal 
%./SZ_rmMain.sh /Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_data/108/ 3 'SZ_2DGaussian'
% First argument - path to folder where mrSESSION.mat is saved
% Second argument  - pRF model to run (refer to rmMain.m for the different options)
% Third argument - output file name 

%%
% Visualize the 3D cortical surface and draw ROIs - V1, V2, V3, ( rest
% later ...)
