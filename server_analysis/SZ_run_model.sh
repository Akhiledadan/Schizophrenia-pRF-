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

if [ -z "$1" ]
then
 echo 'Run_mprf_model. Inputs:'
 echo 'mrSESSION directory=$1, path to the folder containing mrSESSION.mat' 
 echo 'model type to run=$2'
 echo 'outfilename=$3 example='SZ_2DGaussian''
 echo 'pRF model=$4 example='One Gaussian' or 'difference of Gaussian''
 echo 
 exit 1
fi

model="difference of gaussians"

#sub=("100" "107" "110" "114" "202" "205" "208" "211" "214" "301" "304" "307" "312" "315" \
#"104" "108" "111" "200" "203" "206" "209" "212" "218" "302" "305" "309" "313" "316" \
#"106" "109" "112" "201" "204" "207" "210" "300" "306" "310" "314")

sub=("106")

#export sub=("101" "102" "103")
tmp=1
num_sub=$((${#sub[@]}-$tmp))

for cur_sub in `seq 0 $num_sub`
do
    cd /home/p266162/data/25042019/mrvista/${sub[$cur_sub]}

    echo $model

    matlab -nodesktop -nosplash -nojvm -nodisplay -r "warning off; addpath(genpath('/home/p266162/data/pRF_code/Schizophrenia-pRF-/')); addpath(genpath('/home/p266162/data/pRF_code/vistasoft/')); hvol=initHiddenGray; hvol=viewSet(hvol, 'curdt','averages'); hvol=rmLoadParameters(hvol); hvol=refreshScreen(hvol); searchType =$1 ; outFileName='$2'; prfModels={'$model'}; rmMain(hvol,[],searchType,'matFileName', outFileName,'model',prfModels); quit();"

done

