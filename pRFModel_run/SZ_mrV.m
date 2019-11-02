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

roiFileName = 'V123';
prfModels = {'difference of gaussians'};
searchType = 3;
outFileName = 'DoGs_limitSig2maxVal';
sigmaratio = [sqrt(1./(0.9:-0.1:0.1)) 5];
rmMain(VOLUME{1},roiFileName,searchType,'matFileName', outFileName,'model',prfModels,...
    'sigmaratioinfval',40,'sigmaratio',sigmaratio,'sigmaratiomaxval',40);

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

sub_num_all = [{'306','307','309','310','312','313','314','315','316'}];

tot_sub = length(sub_num_all);

for idx_sub = 1:tot_sub

sub_num = sub_num_all{idx_sub};
sub_dir = strcat('/mnt/storage_2/projects/SZ/data/mrvista/',sub_num,'/');

cd(sub_dir);
vANATOMYPATH = strcat(sub_dir,'/Anatomy/n101_t1.nii.gz');
mrSessPath = fullfile(sub_dir, 'mrSESSION.mat');
save(mrSessPath, 'vANATOMYPATH', '-append');

hvol = initHiddenGray;
hvol = viewSet(hvol, 'curdt','Averages');
%figpoint = rmEditStimParams(hvol);
%uiwait(figpoint);


clearvars hvol figpoint sub_dir sub_num;

end



%%
% function to combine multiple rois together in mrVista
combineMultipleRois;


%%

subjects = {'100','101','102','103','104','106','109','110','111','112','114',...
            '200','201','202','203','204','205','206','207','208','209','210','211','212','218'...
            '301','302','304','305','306','307','309','310','312','313','314','315','316'};

numSub = length(subjects);

for sub_idx = 1:numSub
    
    dirPth = SZ_loadPaths;
    
    cd(SZ_rootPath);
    
    
    sub_sess_path  = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
    sub_model_path = fullfile(sub_sess_path,'Gray','Averages');

    cd(sub_sess_path);
    
    %load('Anatomy/ROIs/V123.mat');
    roiFileName = 'V1234';
    
    hvol = initHiddenGray;
    hvol = viewSet(hvol, 'curdt','averages');
    hvol = viewSet(hvol, 'ROI', roiFileName);
    hvol = rmLoadParameters(hvol);
    hvol = refreshScreen(hvol);
    
    
    prfModels = {'difference of gaussians'};
    searchType = 3;
    outFileName = sprintf('DoGs_%s_limitSigRatioSigMaxVal',roiFileName);
    sigmaratio = [sqrt(1./(0.9:-0.1:0.1)) 5];
    rmMain(hvol,roiFileName,searchType,'matFileName', outFileName,'model',prfModels,...
        'sigmaratioinfval',60,'sigmaratio',sigmaratio,'sigmaratiomaxval',40);

end


%% combining one gaussian and difference of gaussians (select 1 gaussian if it performs better than DoGs)


addpath(genpath('/home/akhi/Documents/Programs/dl/dlDevelopment/rmDevel/pRFanalysis'));

subjects = {'100','101','102','103','104','106','109','110','111','112','114',...
            '200','201','202','203','204','205','206','207','208','209','210','211','212','218'...
            '301','302','304','305','306','307','309','310','312','313','314','315','316'};

numSub = length(subjects);

for sub_idx = 1:numSub

dirPth = SZ_loadPaths;

cd(SZ_rootPath);


sub_sess_path  = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
sub_model_path = fullfile(sub_sess_path,'Gray','Averages');
    
rmFileOneG = fullfile(sub_model_path,'SZ_1G-fFit.mat');
rmFileDoG  = fullfile(sub_model_path,'DoGs_V1234_limitSigRatioSigMaxVal-fFit.mat');

cd(sub_model_path);

[CombinedModelName] = combineOneG_DoG(rmFileOneG, rmFileDoG);

fprintf('\n saving subject %s \n',subjects{sub_idx});
end





%% Running the model from terminal 
%./SZ_rmMain.sh /Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_data/108/ 3 'SZ_2DGaussian'
% First argument - path to folder where mrSESSION.mat is saved
% Second argument  - pRF model to run (refer to rmMain.m for the different options)
% Third argument - output file name 

%%
% Visualize the 3D cortical surface and draw ROIs - V1, V2, V3, ( rest
% later ...)


%% only a search fit from grid fit results

subjects = {'100','101','102','103','104','106','109','110','111','112','114',...
            '200','201','202','203','204','205','206','207','208','209','210','211','212','218'...
            '301','302','304','305','306','307','309','310','312','313','314','315','316'};

numSub = length(subjects);

for sub_idx = 1:numSub
    
    dirPth = SZ_loadPaths;
    
    cd(SZ_rootPath);
    
    
    sub_sess_path  = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
    sub_model_path = fullfile(sub_sess_path,'Gray','Averages');

    cd(sub_sess_path);
    
    %load('Anatomy/ROIs/V123.mat');
    roiFileName = 'V123';
    
    hvol = initHiddenGray;
    hvol = viewSet(hvol, 'curdt','averages');
    hvol = viewSet(hvol, 'ROI', roiFileName);
    hvol = rmLoadParameters(hvol);   
    rmFileGrid = fullfile(sub_model_path,'DoGs_limitSig2infVal5-gFit.mat');
    hvol =  viewSet(hvol, 'rmfile', rmFileGrid);
    hvol = refreshScreen(hvol);

    prfModels = {'difference of gaussians'};
    searchType = 2;
    outFileName = sprintf('DoGs_%s_limitSig2InfVal60MaxVal40MaxRatio5',roiFileName);
    
    sigmaratio = [sqrt(1./(0.9:-0.1:0.1)) 5];
    rmMain(hvol,roiFileName,searchType,'matFileName', outFileName,'model',prfModels,...
        'sigmaratioinfval',60,'sigmaratio',sigmaratio,'sigmaratiomaxval',40);

end
