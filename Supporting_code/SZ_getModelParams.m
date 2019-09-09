function [Cond_model,ROI_params] = SZ_getModelParams(opt,dirPth)

%conditions = {'Averages'};
conditions = opt.conditions;
numCond = length(conditions);

% Plot params
MarkerSize = 3;

% Load types of model to compare
model_file = cell(numCond,1);
coords_file = cell(numCond,1);
meanMap_file = cell(numCond,1);

rois = opt.rois;
num_roi = length(rois);
roi_fname = cell(num_roi,numCond,1);

for cond_idx = 1:numCond
    
    cur_cond = conditions{cond_idx};
    switch cur_cond
        case 'ptwH+'
            %            subjects = [{'100'}];
            % sub 107,108 - hallucinations in the scanner - no clear maps
            subjects = [{'100','101','102','103','104','106','109','110','111','112','114'}];
            %            subjects =
            %            [{'100','101','102','103','104','106','109','111','112'}]; % subjects removed due to negative ecc_sig slope
            
                         %subjects = [{'100','101','102','103','104','109','112'}]; % subjects removed due to negative ecc_sursize slope
            
        case 'ptwH-'
            %            subjects = [{'200'}];
            subjects = [{'200','201','202','203','204','205','206','207','208','209','210','211','212','218'}];
            
                        
                        %subjects = [{'200','201','202','203','204','205','206','207','210','211'}];
            
        case 'HC'
            %            subjects = [{'301'}];
            subjects = [{'301','302','304','305','306','307','309','310','312','313','314','315','316'}];
            %            subjects = [{'301','302','305','306','307','309','310','312','313','314','315','316'}];
            %            subjects = [{'301','302','305','306','307','309','312','313','315'}];
             
            %            subjects = [{'301','302','306','307','309','312','313','315'}];
    end
    
    for sub_idx = 1:length(subjects)
        dirPth.sub_sess_path = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
        dirPth.roi_path = strcat(dirPth.sub_sess_path,'Anatomy/ROIs/');
        dirPth.model_path = strcat(dirPth.sub_sess_path,'Gray/Averages');
        dirPth.coords_path = strcat(dirPth.sub_sess_path,'Gray/');
        dirPth.mean_path = strcat(dirPth.sub_sess_path,'Gray/Averages/');
        
        % Load coordinate file
        coordsFile = fullfile(dirPth.coords_path,'coords.mat');
        %load(coordsFile);
        
        % Mean map
        meanMapFile = fullfile(dirPth.mean_path,'meanMap.mat');
        %Mmap = load(meanFile);
        
        if strcmpi(opt.modelType,'DoGs')
            model_fname =  dir(fullfile(dirPth.model_path,'SZ_DoGs-fFit.mat'));
        elseif strcmpi(opt.modelType,'2DGaussian')
            model_fname =  dir(fullfile(dirPth.model_path,'SZ_1G-fFit.mat'));
        end
        
        if length(model_fname)>1
            warning('more than one model fit, selecting the latest one. Select a different model otherwise')
            % Update this with a code to determine the date of model and
            % selecting the latest
        end
        
        model_file{cond_idx,sub_idx} = fullfile(dirPth.model_path,model_fname.name);
        coords_file{cond_idx,sub_idx} = coordsFile;
        meanMap_file{cond_idx,sub_idx} = meanMapFile;
        
        % Select ROIs
        
        for roi_idx = 1:num_roi
            roi_fname{roi_idx,cond_idx,sub_idx} = fullfile(dirPth.roi_path,strcat(rois{roi_idx},'.mat'));
        end
        
    end
end

% Create a table with different conditions and their corresponding model
% files
Cond_model = table(conditions,model_file,coords_file,meanMap_file);

% % Select ROIs
% num_roi = length(rois);
% roi_fname = cell(num_roi,1);
% for roi_idx = 1:num_roi
%     roi_fname{roi_idx,1} = fullfile(paths.roi_path,strcat(rois{roi_idx},'.mat'));
% end

% Table with different ROIs and their corresponding file paths
ROI_params = table(rois,roi_fname);

%% calculating pRF parameters to compare - this has to be done for each subject separately.

% preallocate variables

model_data = cell(1);
index_thr_tmp = cell(1);
model_data_thr = cell(1);

numSubjects = nan(numCond,1);
for cond_idx = 1:numCond
    fprintf('Loading model for condition %d \n',cond_idx);
    
    numSub = sum(~cellfun(@isempty,Cond_model.model_file(cond_idx,:)),2); % check if subjects field is empty
    numSubjects(cond_idx,1) = numSub;
    
    fprintf('Loading model for subject ');
    for sub_idx = 1:numSub
        
        fprintf('... %d',sub_idx);
        
        % Load coordinate file
        coordsFile = Cond_model.coords_file{cond_idx,sub_idx};
        load(coordsFile);
        
        % Mean map
        meanFile = Cond_model.meanMap_file{cond_idx,sub_idx};
        Mmap = load(meanFile);
        
        % Determine the voxels for different ROIs and the corresponding prf
        % parameters
        for roi_idx = 1:num_roi
            %Load the current roi
            load(ROI_params.roi_fname{roi_idx,cond_idx,sub_idx});
            
            % find the indices of the voxels from the ROI intersecting with all the voxels
            [~, indices_mean] = intersect(coords', ROI.coords', 'rows' );
            mean_map = Mmap.map{1}(1,indices_mean);
            
            % Current model parameters- contains x,y, sigma, from current
            % condition and current subject and for the current ROI
            model_data(cond_idx,sub_idx,roi_idx) = GetInfoModel(Cond_model.model_file{cond_idx,sub_idx},coordsFile,ROI_params.roi_fname{roi_idx,cond_idx,sub_idx});
            
            % Difference of gaussians parameters
            rm = load(Cond_model.model_file{cond_idx,sub_idx});
            if strcmpi(opt.modelType,'DoGs')
                [fwhmax,surroundSize,fwhmin_first, fwhmin_second, diffwhmin, surr_depth] = rmGetDoGFWHM(rm.model{1},{indices_mean});
                model_data{cond_idx,sub_idx,roi_idx}.DoGs_fwhmax = fwhmax;
                model_data{cond_idx,sub_idx,roi_idx}.DoGs_surroundSize = surroundSize;
                model_data{cond_idx,sub_idx,roi_idx}.DoGs_fwhmin_first = fwhmin_first;
                model_data{cond_idx,sub_idx,roi_idx}.DoGs_fwhmin_second = fwhmin_second;
                model_data{cond_idx,sub_idx,roi_idx}.DoGs_diffwhmin = diffwhmin;
                model_data{cond_idx,sub_idx,roi_idx}.DoGs_surr_depth = surr_depth;
                
            end
            
            % For every condition and roi, save the index_thr and add them to
            % the Cond_model table so that they can be loaded later
            index_thr_tmp{cond_idx,sub_idx,roi_idx} = model_data{cond_idx,sub_idx,roi_idx}.varexp > opt.varExpThr & model_data{cond_idx,sub_idx,roi_idx}.ecc < opt.eccThr(2) & model_data{cond_idx,sub_idx,roi_idx}.ecc > opt.eccThr(1) & mean_map > opt.meanMapThr;
            
            % Determine the thresholded indices for each of the ROIs
            %roi_index{roi_idx,1} = index_thr_tmp{1,1} & index_thr_tmp{2,1};
            roi_index{cond_idx,sub_idx,roi_idx} = index_thr_tmp{cond_idx,sub_idx,roi_idx};
            
            % Apply these thresholds on the pRF parameters for both the conditions
            model_data_thr{cond_idx,sub_idx,roi_idx} = NP_params_thr(model_data{cond_idx,sub_idx,roi_idx},roi_index{cond_idx,sub_idx,roi_idx},opt);
            
            % Store the thresholded pRF values in a table
            %add_t_1{sub_idx} = table(model_data_thr{cond_idx,sub_idx,roi_idx},'VariableNames',ROI_params.rois(roi_idx));
        end
    end
end

% Update Cond_model with number of subjects for each conditions
add_t_sub = table(numSubjects);
Cond_model = [Cond_model add_t_sub];

for roi_idx = 1:num_roi
    for cond_idx = 1:numCond
        numSub = Cond_model.numSubjects(cond_idx);
        for sub_idx = 1:numSub
            model_data_thr_t{cond_idx,sub_idx} = model_data_thr{cond_idx,sub_idx,roi_idx};
            
        end
    end
    add_t_1 = table(model_data_thr_t,'VariableNames',ROI_params.rois(roi_idx));
    
    
    if roi_idx == 1
        add_t_rois = add_t_1;
    else
        add_t_rois = [add_t_rois add_t_1];
    end
    
end

% Update Cond_model table with the model parameters. Each row contains same
% condition, with ROIs marked with their respective names. Within each roi,
% there is a structure with all model parameters for each subject.


Cond_model = [Cond_model add_t_rois];

if opt.saveRes
    
   dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
   if ~exist('saveDir','dir')
       mkdir(dirPth.saveDirPrfParams);
   end 
           
   filename_res = 'prfParams.mat';
   save(fullfile(dirPth.saveDirPrfParams,filename_res),'Cond_model','ROI_params');
    
end



end
% Update the ROI_params with the thresholded index values
% add_t_1_roi = table(roi_index);
% ROI_params = [ROI_params add_t_1_roi];