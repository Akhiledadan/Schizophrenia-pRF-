% Make the surface plots for all subjects and save the screenshots of
% eccentricity and polar angle maps


% subjects = {'100','101','102','103','104','106','109','110','111','112','114',...
%     '200','201','202','203','204','205','206','207','208','209','210','211','212','218'...
%     '301','302','304','305','306','307','309','310','312','313','314','315','316'};

close all;
subjects = {'307'};

numSub = length(subjects);

for sub_idx = 1:numSub
    
    dirPth = SZ_loadPaths;
    
    cd(SZ_rootPath);
    
    
    sub_sess_path  = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
    sub_model_path = fullfile(sub_sess_path,'Gray','Averages');
    anatDir        = fullfile(sub_sess_path,'Anatomy'); 
    
    % Go to vista session and open a mrVista Gray window    
    cd(sub_sess_path);
    VOLUME{1} = mrVista('3');
    
    VOLUME{1} = viewSet(VOLUME{1}, 'curdt','averages');
    VOLUME{1} = refreshScreen(VOLUME{1});
    
    % Load rh and lh mesh
    mesh1 = fullfile(anatDir,  'Left_inflated.mat');
    mesh2 = fullfile(anatDir,  'Right_inflated.mat');
    [VOLUME{1}, OK] = meshLoad(VOLUME{1}, mesh1, 1); if ~OK, error('Mesh server failure'); end
    [VOLUME{1}, OK] = meshLoad(VOLUME{1}, mesh2, 1); if ~OK, error('Mesh server failure'); end
   
    
    
end

