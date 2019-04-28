function SZ_mrWang(mrV_subj_folder,vistasoft_path,FS_subj_folder)

  addpath(genpath(vistasoft_path));

  cd mrV_subj_folder 

  # cd to the mrVista session directory
  vw = initHiddenGray;

  wangAtlasPath = sprintf(fullfile(FS_subj_folder, 'mri', 'native.wang2015_atlas.mgz'));

  % Convert mgz to nifti
  [pth, fname] = fileparts(wangAtlasPath);

  wangAtlasNifti = fullfile(pth, sprintf('%s.nii.gz', fname));

  ni = MRIread(wangAtlasPath);
  MRIwrite(ni, wangAtlasNifti);

  % Load the nifti as ROIs
  vw = wangAtlasToROIs(vw, wangAtlasNifti);

  % Save the ROIs
  local = false; forceSave = true;
  saveAllROIs(vw, local, forceSave);

end
