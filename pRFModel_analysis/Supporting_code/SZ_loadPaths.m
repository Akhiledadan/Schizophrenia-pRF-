function dirPth = SZ_loadPaths

%% ----- General -----
dirPth  = struct();
dirPth.rootPth = SZ_rootPath;

%% ----- mrVista path -----
dirPth.mrvDirPth     = fullfile(SZ_rootPath,'data','mrvista');

%% ----- freesurfer paths ------
dirPth.freesurferPth     = fullfile(SZ_rootPath,'data','freesurfer');


%% ----- folder to save results (figures, data) ------

dirPth.saveDirFig     = fullfile(SZ_rootPath,'data','plots');
dirPth.saveDirRes     = fullfile(SZ_rootPath,'data','results');

%% ----- MS figures -------
dirPth.saveDirMSFig   = fullfile(SZ_rootPath,'data','plots','MS_Figure');
dirPth.saveDirMSFigures = fullfile(SZ_rootPath,'data','MS');
