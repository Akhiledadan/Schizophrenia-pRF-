function data = SZ_getTimeSeries(dirPth,opt)
% SZ_getTimeSeries - Extract raw time series from the model file and
% generate the plot for Schizophrenic (with and without hallucination) and control populations
%
% input - dirPth : Path to the directory containing model files
%       - opt    : different options
%
% 04/10/2019: written by Akhil Edadan (a.edadan@uu.nl)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes long time to load - preload and save
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%conditions = {'Averages'};
conditions = opt.conditions;
numCond = length(conditions);

rois = opt.rois;
numRoi = length(rois);
roi_fname = cell(numRoi,numCond,1);


numSubMax = max([length(opt.subjects.ptH),length(opt.subjects.ptNH),length(opt.subjects.HC)]);
data.timeSeries_rois = cell(numCond,numSubMax,numRoi);

if opt.getTimeSeries
    
    
    for cond_idx = 1:numCond % for 3 conditions (ptH, ptNH, HC)
        
        curCond = conditions{cond_idx};
        fprintf('%s...',curCond);
        
        switch curCond
            case 'ptH'
                subjects = opt.subjects.ptH;
            case 'ptNH'
                subjects = opt.subjects.ptNH;
            case 'HC'
                subjects = opt.subjects.HC;
        end
        
        for sub_idx = 1:length(subjects) % for the subjects within each condition (11,14,13 respectively)
            
            curSub = subjects{sub_idx};
            fprintf('%s...',curSub);
            
            dirPth.subSessPth = fullfile(dirPth.mrvDirPth,'/',curSub,'/');
            dirPth.roiPth = strcat(dirPth.subSessPth,'Anatomy/ROIs/');
            dirPth.modelPth = strcat(dirPth.subSessPth,'Gray/Averages');
            dirPth.coordsPth = strcat(dirPth.subSessPth,'Gray/');
            dirPth.meanPth = strcat(dirPth.subSessPth,'Gray/Averages/');
            
            % pRF model 
            if strcmpi(opt.modelType,'DoGs')
                model_fname =  dir(fullfile(dirPth.modelPth,opt.modelDoG));
            elseif strcmpi(opt.modelType,'2DGaussian')
                model_fname =  dir(fullfile(dirPth.modelPth,opt.model2DG));
            end
            
            if length(model_fname)>1
                warning('more than one model fit, selecting the latest one. Select a different model otherwise')
                % Update this with a code to determine the date of model and
                % selecting the latest
            end
            
            % Select ROIs
            for roi_idx = 1:numRoi
                roi_fname{roi_idx,cond_idx,sub_idx} = fullfile(dirPth.roiPth,strcat(rois{roi_idx},'.mat'));
            end
            
            %% extracting the time series
            
            cd(dirPth.subSessPth);
            
            hView = initHiddenGray;
            
            curCond = opt.conditions{cond_idx};
            
            hView = viewSet(hView,'curdt','Averages');
            hView = rmSelect(hView,1,fullfile(model_fname.folder,model_fname.name));
            
            params = viewGet(hView, 'rmParams');
            
            for roi_idx =1:numRoi % for all the rois (V1, V2, V3)
                
                curRoi = opt.rois{roi_idx};
                fprintf('%s...',curRoi);
                
                load(fullfile(dirPth.roiPth,[curRoi '.mat']));
                
                ts_fileName = sprintf('TS_%s_%s_%s',curCond,curSub,curRoi);
                ts_fullFileName = fullfile(dirPth.modelPth,ts_fileName);
                
                % check if there are time series data already saved. If yes, load them
                % instead of reextracting.
                
                if ~exist([ts_fullFileName '.mat'],'file')

                    % get time series and roi-coords
                    [TS.tSeries, TS.coords, TS.params] = rmLoadTSeries(hView, params, ROI, 0);
                    
                    % detrend
                    % get/make trends
                    trends  = rmMakeTrends(params);
                    
                    % recompute
                    b = pinv(trends)*TS.tSeries;
                    TS.tSeries = TS.tSeries - trends*b;
                    
                    data.timeSeries_rois{cond_idx,sub_idx,roi_idx} = TS;
                    
                    save(ts_fullFileName,'TS');
                    fprintf('saving roi: %s for condition: %s for subject %s \n',curCond,curSub,curRoi);
                    
                    
                else
                    
                    if opt.recomputeTimeSeries
                        % get time series and roi-coords
                        [TS.tSeries, TS.coords, TS.params] = rmLoadTSeries(hView, params, ROI, 0);
                        
                        % detrend
                        % get/make trends
                        trends  = rmMakeTrends(params);
                        
                        % recompute
                        b = pinv(trends)*TS.tSeries;
                        TS.tSeries = TS.tSeries - trends*b;
                        
                        data.timeSeries_rois{cond_idx,sub_idx,roi_idx} = TS;
                        
                        save(ts_fullFileName,'TS');
                        fprintf('saving roi: %s for condition: %s for subject %s \n',curCond,curSub,curRoi);
                    else
                        fprintf('loading roi: %s for condition: %s for subject %s \n',curRoi,curCond,curSub);
                        ts_fileName = sprintf('TS_%s_%s_%s',curCond,curSub,curRoi);
                        ts_fullFileName = fullfile(dirPth.modelPth,ts_fileName);
                        load(ts_fullFileName);
                        data.timeSeries_rois{cond_idx,sub_idx,roi_idx} = TS;
                    end
                end 
                
            end % roi 
        end % subject
    end % condition

else
    
    numCond = length(opt.conditions);
    numRoi  = length(opt.rois);
    for cond_idx = 1:numCond
        
        curCond = conditions{cond_idx};
        
        switch curCond
            case 'ptH'
                subjects = opt.subjects.ptH;
            case 'ptNH'
                subjects = opt.subjects.ptNH;
            case 'HC'
                subjects = opt.subjects.HC;
        end
        
        for sub_idx = 1:length(subjects) % for the subjects within each condition (11,14,13 respectively)
            
            curSub = subjects{sub_idx};
            
            dirPth.subSessPth = fullfile(dirPth.mrvDirPth,'/',curSub,'/');
            dirPth.roiPth = strcat(dirPth.subSessPth,'Anatomy/ROIs/');
            dirPth.modelPth = strcat(dirPth.subSessPth,'Gray/Averages');
            dirPth.coordsPth = strcat(dirPth.subSessPth,'Gray/');
            dirPth.meanPth = strcat(dirPth.subSessPth,'Gray/Averages/');
            
            for roi_idx = 1:numRoi
                curRoi = opt.rois{roi_idx};
                ts_fileName = sprintf('TS_%s_%s_%s',curCond,curSub,curRoi);
                ts_fullFileName = fullfile(dirPth.modelPth,[ts_fileName '.mat']);
                load(ts_fullFileName);
                data.timeSeries_rois{cond_idx,sub_idx,roi_idx} = TS;
            end
        end
        
    end
    
    
    
end

end % end of function