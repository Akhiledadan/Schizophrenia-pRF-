% Script to add the units for all the functionals in the folder 

fprintf('Start adding units xyz and time >>>>>>>>>>')

files = dir(strcat(sess_dir,'/Functionals/','**.nii'));

n_files = length(files);

for i= 1:n_files
    f_name = files(i).name;
    SZ_Addunits(strcat(sess_dir,'/Functionals/',f_name));
end

fprintf('\n Done \n');