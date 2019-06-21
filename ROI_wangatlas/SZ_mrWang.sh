#!/bin/bash
#SBATCH --time=2-12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4 # Here we set 3 CPU's for this task.
#SBATCH --job-name=SZ_prf
#SBATCH --output=matlab_sz_prf.index.out
#SBATCH --mem=40000
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=akhilddn5@gmail.com

module load MATLAB/2017b-GCC-4.9.3-2.25

sub=("107" "110" "114" "202" "205" "208" "211" "214" "301" "304" "307" "312" "315" \
"104" "108" "111" "200" "203" "206" "209" "212" "218" "302" "305" "309" "313" "316" \
"106" "109" "112" "201" "204" "207" "210" "300" "306" "310" "314")

#sub=("103")

#export sub=("101" "102" "103")
tmp=1
num_sub=$((${#sub[@]}-$tmp))

for cur_sub in `seq 0 $num_sub`
do
  
  matlab -nodesktop -nosplash -nojvm -nodisplay -r "warning off;FS_subj_folder='/data/p266162/25042019/freesurfer/${sub[$cur_sub]}/';mrV_subj_folder='/data/p266162/25042019/mrvista/${sub[$cur_sub]}/';code_path.vistasoft_path='/home/p266162/data/pRF_code/vistasoft';code_path.Wroi_path='/home/p266162/data/pRF_code/Schizophrenia-pRF-'; addpath(genpath('/home/p266162/data/pRF_code/Schizophrenia-pRF-')); SZ_mrWang(mrV_subj_folder,FS_subj_folder,code_path); quit();"

done

