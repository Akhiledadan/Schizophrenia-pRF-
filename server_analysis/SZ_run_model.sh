#!/bin/bash
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=3 # Here we set 3 CPU's for this task.
#SBATCH --job-name=mcmc_tiny
#SBATCH --output=matlab_mcmc_tinyx.index.out
#SBATCH --mem=40000

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

cd $1

echo $3

matlab -nodesktop -nosplash -nojvm -nodisplay -r "warning off; addpath(genpath('/home/p266162/data/pRF_code/Schizophrenia-pRF-/')); addpath(genpath('/home/p266162/data/pRF_code/vistasoft/')); hvol=initHiddenGray; hvol=viewSet(hvol, 'curdt','averages'); hvol=rmLoadParameters(hvol); hvol=refreshScreen(hvol); searchType =$2 ; outFileName='$3'; prfModels={'$4'}; rmMain(hvol,[],searchType,'matFileName', outFileName,'model',prfModels); quit();"
 

