main_dir = '/mnt/storage_2/projects/SZ/data/mrvista';
sub = [{'100','200','301'}];
num_sub = length(sub);

for idx_sub = 1:num_sub

    roi_dir = strcat(main_dir,'/',sub(idx_sub),'/Anatomy/ROIs/');     
    rois = dir(fullfile(roi_dir{1},'Wang*'));
    
    num_roi = length(rois);
    
    for idx_roi = 1:num_roi
        load(fullfile(roi_dir{1},rois(idx_roi).name))
        ROI.coords(1,:) = ROI.coords(1,:)-1;
        ROI.coords(3,:) = ROI.coords(3,:)+1;
        
        save_name = fullfile(roi_dir{1},rois(idx_roi).name);
        save(save_name,'ROI')
        clear ROI
    end
    
end