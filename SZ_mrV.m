% Initializing the session and running mrVista 


%% 
mrInit;

% Clip 8 frames from the beginning
% Keep 128 frames after the clipped frames


%%
% Run pRF model for a small ROI on inplane view as a check
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


roiFileName = [];
prfModels = {'one gaussian'};
searchType = 3;
outFileName = 'SZ_2DGaussian';
rmMain(VOLUME{1},[],searchType,'matFileName', outFileName,'model',prfModels);


%%
% Visualize the 3D cortical surface and draw ROIs - V1, V2, V3, ( rest
% later ...)
