function modelData = SZ_getModelParams(opt,dirPth)
% SZ_getModelParams - function to extract pRF model parameters into different ROIs
%
% input  - dirPth     : directory where pRF model is saved
% output - Cond_model : table containing ROI


%conditions = {'Averages'};
conditions = opt.conditions;
numCond = length(conditions);

rois = opt.rois;
numRoi = length(rois);

numSubMax = max([length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]);

modelData.modelInfo      = cell(numCond,numSubMax,numRoi);
modelData.roi_index      = cell(numCond,numSubMax,numRoi);
modelData.modelInfo_thr  = cell(numCond,numSubMax,numRoi);

% choose the model file 
if strcmpi(opt.modelType,'DoGs')
    cur_model = opt.modelDoG;
elseif strcmpi(opt.modelType,'2DGaussian')
    cur_model = opt.model2DG;
end
fprintf('selecting model - %s',cur_model);

for cond_idx = 1:numCond
    
    cur_cond = conditions{cond_idx};
    switch cur_cond
        case 'ptH'           
            subjects = opt.subjects.ptH;            
        case 'ptNH'            
            subjects = opt.subjects.ptNH;            
        case 'HC'           
            subjects = opt.subjects.HC;    
    end
    
    numSub = length(subjects);
    
    for sub_idx = 1:numSub
        
        curSub = subjects{sub_idx};
        fprintf('%s...',curSub);
        
        dirPth.sub_sess_path = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
        dirPth.roi_path = strcat(dirPth.sub_sess_path,'Anatomy/ROIs/');
        dirPth.model_path = strcat(dirPth.sub_sess_path,'Gray/Averages');
        dirPth.coords_path = strcat(dirPth.sub_sess_path,'Gray/');
        dirPth.mean_path = strcat(dirPth.sub_sess_path,'Gray/Averages/');
        
        % Load coordinate file
        coordsFile = fullfile(dirPth.coords_path,'coords.mat');
        
        % Mean map
        meanMapFile = fullfile(dirPth.mean_path,'meanMap.mat');
        
        model_fname =  dir(fullfile(dirPth.model_path,cur_model));
        
        if length(model_fname)>1
            warning('more than one model fit, selecting the latest one. Select a different model otherwise')
            % Update this with a code to determine the date of model and
            % selecting the latest
        end
        
        modelData.model_file{cond_idx,sub_idx} = fullfile(dirPth.model_path,model_fname.name);
        modelData.coords_file{cond_idx,sub_idx} = coordsFile;
        modelData.meanMap_file{cond_idx,sub_idx} = meanMapFile;
        
        % Load coords file for a subject
        load(coordsFile);
        Mmap = load(meanMapFile);
        


        for roi_idx = 1:numRoi
            
            curRoiPth = fullfile(dirPth.roi_path,strcat(rois{roi_idx},'.mat'));
            roi_fname{cond_idx,sub_idx,roi_idx} = curRoiPth;
            
            %Load the current roi
            load(curRoiPth);
            
            % find the indices of the voxels from the ROI intersecting with all the voxels
            [~, indices_mean] = intersect(coords', ROI.coords', 'rows' );
            mean_map = Mmap.map{1}(1,indices_mean);
            
            % Current model parameters- contains x,y, sigma, from current
            % condition and current subject and for the current ROI
            model_data = GetInfoModel(modelData.model_file{cond_idx,sub_idx},coordsFile,curRoiPth);
            model_data{1}.beta = model_data{1}.beta';
            model_data{1}.sigmaFWHM = model_data{1}.sigma .* 2.355; % FWHM = sigma .* 2.355
            
            % Difference of gaussians parameters
            rm = load(modelData.model_file{cond_idx,sub_idx});
            if strcmpi(opt.modelType,'DoGs')
                [fwhmax,surroundSize,fwhmin_first, fwhmin_second, diffwhmin,~] = rmGetDoGFWHM(rm.model{1},{indices_mean});
                stimRadius = 5;
                [suppressionIndex, ~, ~, ~, ~] = rmGetDoGSuppressionIndex(rm.model{1},'roi',indices_mean,'sts',stimRadius);
                model_data{1}.DoGs_fwhmax = fwhmax;
                model_data{1}.DoGs_surroundSize = surroundSize;
                model_data{1}.DoGs_fwhmin_first = fwhmin_first;
                model_data{1}.DoGs_fwhmin_second = fwhmin_second;
                model_data{1}.DoGs_diffwhmin = diffwhmin;
                model_data{1}.DoGs_suppressionIndex = suppressionIndex;
%                 model_data{1}.DoGs_beta1 = beta1;
%                 model_data{1}.DoGs_beta2 = beta2;
            end
            
            % For every condition and roi, save the index_thr and add them to
            % the Cond_model table so that they can be loaded later
            index_thr_tmp = model_data{1}.varexp > opt.varExpThr & model_data{1}.ecc < opt.eccThr(2) & model_data{1}.ecc > opt.eccThr(1) & mean_map > opt.meanMapThr;
            
            % Determine the thresholded indices for each of the ROIs
            %roi_index{roi_idx,1} = index_thr_tmp{1,1} & index_thr_tmp{2,1};
            modelData.roi_index{cond_idx,sub_idx,roi_idx} = index_thr_tmp;
                       
            % Apply these thresholds on the pRF parameters for both the conditions
            model_data_thr = SZ_params_thr(model_data{1},modelData.roi_index{cond_idx,sub_idx,roi_idx},opt);
 
            modelData.modelInfo{cond_idx,sub_idx,roi_idx}     = model_data{1};
            modelData.modelInfo_thr{cond_idx,sub_idx,roi_idx} = model_data_thr;
            
        end
     
    end
end

%% save data

if opt.saveRes
    
    dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
    if ~exist('saveDir','dir')
        mkdir(dirPth.saveDirPrfParams);
    end
    
    filename_res = 'prfParams.mat';
    save(fullfile(dirPth.saveDirPrfParams,filename_res),'modelData');
    
end



end
