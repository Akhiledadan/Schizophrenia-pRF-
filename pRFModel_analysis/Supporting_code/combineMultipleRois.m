function combineMultipleRois
% Function to combine multiple ROIs in mrVista (.mat) space 
% roisToCombine - name of the combined roi
% rois          - rois in the anatomy/ROIs folder inside the mrSession folder
% 
% 07/10/2019: written by Akhil Edadan (a.edadan@uu.nl) using mrVista functions


subjects = {'100','101','102','103','104','106','109','110','111','112','114',...
            '200','201','202','203','204','205','206','207','208','209','210','211','212','218'...
            '301','302','304','305','306','307','309','310','312','313','314','315','316'};


dirPth = SZ_loadPaths;
%roisToCombine = {'V1','V2','V3'};
%rois = [{'WangAtlas_V1v'};{'WangAtlas_V1d'};{'WangAtlas_V2v'};{'WangAtlas_V2d'};{'WangAtlas_V3v'};{'WangAtlas_V3d'}];

roisToCombine = {'V1234'};
rois = [{'V1','V2','V3','WangAtlas_hV4'}];

for sub_idx = 1:length(subjects)
    dirPth.sub_sess_path = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
    dirPth.roi_path = strcat(dirPth.sub_sess_path,'Anatomy/ROIs/');
    dirPth.coords_path = strcat(dirPth.sub_sess_path,'Gray/');
    saveDir = dirPth.roi_path;
    
    load(fullfile(dirPth.coords_path,'coords.mat'));
    
    % Combine ROIs
    for rc = 1:length(roisToCombine)
        match = contains(rois,roisToCombine{rc});
        
        %matchIdx = find(match);
        
        matchIdx = 1:length(rois);
        tmpData = [];
        for ii = 1:length(matchIdx)
            load(fullfile(dirPth.roi_path, rois{matchIdx(ii)}));
            [~, indices] = intersect(coords', ROI.coords', 'rows' );
            tmpData = [tmpData; indices];
        end
        
        roiName{rc} = roisToCombine{rc};
        roiLoc{rc} = unique(tmpData, 'rows');
        roiCoords{rc} = coords(:,roiLoc{rc});
        
        ROI.coords = roiCoords{rc};
        ROI.name = roisToCombine{rc};
        save(fullfile(saveDir,roiName{rc}),'ROI');            
        
    end
    
end

end
