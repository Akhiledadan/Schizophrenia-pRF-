function dirPth = loadPaths

%% ----- General -----
dirPth  = struct();
dirPth.rootPth = SZ_rootPath;

%% ----- mrVista path -----
dirPth.mrvDirPth     = fullfile(SZ_rootPath,'data','mrvista');

%% ----- freesurfer paths ------
dirPth.freesurferPth     = fullfile(SZ_rootPath,'data','freesurfer');

