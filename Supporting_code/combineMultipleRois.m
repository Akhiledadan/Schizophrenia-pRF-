function combineMultipleRois
% Function to combine multiple ROIs in mrVista (.mat) space 

subjects = {'100','200','301'};

dirPth = loadPaths;
roisToCombine = {'V1','V2','V3'};
rois = [{'WangAtlas_V1v'};{'WangAtlas_V1d'};{'WangAtlas_V2v'};{'WangAtlas_V2d'};{'WangAtlas_V3v'};{'WangAtlas_V3d'}];

for sub_idx = 1:length(subjects)
    dirPth.sub_sess_path = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
    dirPth.roi_path = strcat(dirPth.sub_sess_path,'Anatomy/ROIs/');
    dirPth.coords_path = strcat(dirPth.sub_sess_path,'Gray/');
    saveDir = dirPth.roi_path;
    
    load(fullfile(dirPth.coords_path,'coords.mat'));
    
    % Combine ROIs
    for rc = 1:length(roisToCombine)
        match = contains(rois,roisToCombine(rc));
        
        matchIdx = find(match);
        tmpData = [];
        for ii = 1:length(matchIdx)
            load(fullfile(dirPth.roi_path, rois{matchIdx(ii)}));
            [~, indices] = intersect(coords', ROI.coords', 'rows' );
            tmpData = [tmpData; indices];
        end
        
        roiName(rc) = roisToCombine(rc);
        roiLoc{rc} = unique(tmpData, 'rows');
        roiCoords{rc} = coords(:,roiLoc{rc});
        
        ROI.coords = roiCoords{rc};
        ROI.name = roisToCombine{rc};
        save(fullfile(saveDir,roiName{rc}),'ROI');            
        
    end
    
end

end