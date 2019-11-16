% subjects used in the MS - 100, 200, 307

subjects = {'200'};

numSub = length(subjects);

for sub_idx = 1:numSub
    
    dirPth = SZ_loadPaths;
    
    cd(SZ_rootPath);
    
    sub_sess_path  = fullfile(dirPth.mrvDirPth,'/',subjects{sub_idx},'/');
    sub_model_path = fullfile(sub_sess_path,'Gray','Averages');
    anatDir        = fullfile(sub_sess_path,'Anatomy');
    
    roiFileName = 'V1234';
    
    % rh and lh mesh names to save
    mesh1 = fullfile(anatDir,'Left_inflated.mat');
    mesh2 = fullfile(anatDir,'Right_inflated.mat');
    
    % Go to vista session and open a mrVista Gray window
    cd(sub_sess_path);

    
    hvol = mrVista('3');
    hvol = viewSet(hvol, 'curdt','Averages');
    hvol = refreshScreen(hvol);

    hs = {'left';'right'};
    
    for hs_idx = 1:length(hs)
        
        curHs = hs{hs_idx};
        
        % Build meshes
        hvol = meshBuild(hvol, curHs);
        MSH = meshVisualize( viewGet(hvol, 'Mesh') );
        MSH = meshSmooth(MSH,1);
        hvol = viewSet(hvol, 'Mesh', MSH);
        
        mrmWriteMeshFile( viewGet( hvol, 'Mesh'),viewGet(hvol, 'MeshDir') );
        clear MSH;
        
        % Update views
        hvol = refreshScreen(hvol);
        hvol = meshUpdateAll(hvol);
        
    end
    
end


