% Steps for SZ analysis - 
%
%
%Creating the mrVista session directory
% Written AE (05.03.2019)

% Only thing to change for mutiple subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sub_num_all = [{'103'},{'104'},{'106'},{'107'},{'108'},{'109'},{'110'},{'111'},{'112'},{'114'}];
%sub_num_all = [{'200'},{'201'},{'202'},{'203'},{'204'},{'205'},{'206'},{'207'},{'208'},{'209'},{'210'},{'211'},{'212'},{'213'},{'214'},{'218'}];
sub_num_all = [{'301','302','303','304','305','306','307','309','310','312','313','314','315','316'}];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Contains all the codes
addpath(genpath('/Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_code/'))


%% 
% Make the mrSession directory

tot_sub = length(sub_num_all);

for idx_sub = 1:tot_sub

sub_num = sub_num_all{idx_sub};
    
% Main director within which all the mrVista sessions are present
main_dir = '/Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_data/';
% Directory containing mrSESSION.mat
sess_dir = strcat(main_dir,sub_num);

% Original location of functionals and anatomy
prfaligned_dir = '/Volumes/Marouska/pRFallfiles/pRFaligned/';
prfaligned_dir_func = strcat(prfaligned_dir,sub_num,'/Functional/');
prfaligned_dir_Anat = strcat(prfaligned_dir,sub_num,'/Structural/');

% Original location of stimulus image and params
stim_dir = '/Volumes/Marouska/pRFallfiles/Params_pRF/Stimuli/';

% Original location of segmentation files (freesurfer directory)
main_seg_dir = strcat('/Volumes/Marouska/pRFallfiles/freesurfer_segmentation/',sub_num,'/');

orig_anat = strcat('/Volumes/Marouska/pRFallfiles/freesurfer_segmentation/',sub_num,'/mri/orig.mgz');
orig_seg = strcat('/Volumes/Marouska/pRFallfiles/freesurfer_segmentation/',sub_num,'/mri/ribbon.mgz');
FS_anat = strcat('/Volumes/Marouska/pRFallfiles/freesurfer_segmentation/',sub_num,'/final_files/n101_t1.nii.gz'); % Here by mistake all segmentations/anatomy are named with prefix n101_..., but they are all different.
FS_seg = strcat('/Volumes/Marouska/pRFallfiles/freesurfer_segmentation/',sub_num,'/final_files/n101_t1_class.nii.gz');
fin_seg_dir = strcat(main_seg_dir,'final_files/');
mkdir(fin_seg_dir);

% Directory to change the segmentation to be mrVista compatible
mrV_seg_dir = strcat(fin_seg_dir,'mrV_seg_dir');

%% 
% Convert freesurfer segmentation to mrVista compatible segmentation

% Extracting segmentation files from freesurfer directories

%setenv( 'FREESURFER_HOME','/Applications/freesurfer');
%system('source /Applications/freesurfer/setUpFreeSurfer.sh');

bash_path=getenv ('PATH');
setenv( 'PATH',[bash_path,':/Applications/freesurfer',':/Applications/freesurfer/bin']);
system(sprintf('mri_convert --out_orientation RAS  -rt nearest %s %s',orig_anat,FS_anat));
system(sprintf('mri_convert --out_orientation RAS  -rt nearest %s %s %s',orig_seg,FS_seg));

mkdir(mrV_seg_dir);
copyfile(FS_seg,mrV_seg_dir);
copyfile(FS_anat,mrV_seg_dir);

cd(mrV_seg_dir)
% Relabeling the segmentation to ,make it mrVista comaptible
fs_niftiribbon2itk('n101_t1_class.nii.gz',1);

tmp = niftiRead('n101_t1_class.nii.gz');
tmp_2 = unique(tmp.data);
disp(tmp_2);

cd .. 

%% 
% Make the mrSession directories and copy the required files

mkdir(sess_dir);
cd(sess_dir);

mkdir('Functionals');
mkdir('Anatomy');
mkdir('Stimuli');

% Copying functional runs 
func_files_info = dir(strcat('/Volumes/Marouska/pRFallfiles/pRFaligned/',sub_num,'/Functional/*_bars*'));

func_files = cell(length(func_files_info),1);
for i =1:length(func_files_info)
    func_files{i} = func_files_info(i).name;
    copyfile(fullfile(prfaligned_dir_func,func_files{i}),strcat(sess_dir,'/Functionals'));

end

% Functional data for some reason don't have xyz and time units - so, they
% have to be added. 
% Run SZ_Addunits_main.m from the "Functionals" directory. This will add
% the units for xyz and time and save the functionals with a new name with
% "oldnameoffunctionals_U.nii"
cd(sess_dir);
SZ_Addunits_main;


% Copying T1-w anatomy, freesurfer segmentation and inplane anatomy to
% mrSession directory

Anat_files_info = dir(strcat(mrV_seg_dir,'/','*.nii.gz'));

Anat_files = cell(length(Anat_files_info),1);
for i =1:length(Anat_files_info)
    Anat_files{i} = Anat_files_info(i).name;
    copyfile(fullfile(mrV_seg_dir,Anat_files{i}),strcat(sess_dir,'/Anatomy'));

end

Inp_Anat_files_info = dir(strcat('/Volumes/Marouska/pRFallfiles/pRFaligned/',sub_num,'/Structural/*_10*'));
Inp_Anat_files = cell(length(Inp_Anat_files_info),1);
for i =1:length(Inp_Anat_files_info)
    Inp_Anat_files{i} = Inp_Anat_files_info(i).name;
    copyfile(fullfile(prfaligned_dir_Anat,Inp_Anat_files{i}),strcat(sess_dir,'/Anatomy'));

end

% Copying Stimulus files

stim_files_info = dir(strcat(stim_dir,'/','*.mat'));

stim_files = cell(length(stim_files_info),1);
for i =1:length(stim_files_info)
    stim_files{i} = stim_files_info(i).name;
    copyfile(fullfile(stim_dir,stim_files{i}),strcat(sess_dir,'/Stimuli'));

end






end



