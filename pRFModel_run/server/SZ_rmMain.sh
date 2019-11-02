#!/bin/bash

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
 
/Applications/MATLAB_R2014b.app/bin/matlab -nodesktop -nosplash -nojvm -nodisplay -r "warning off; addpath(genpath('/Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_code/')); hvol=initHiddenGray; hvol=viewSet(hvol, 'curdt','averages'); hvol=rmLoadParameters(hvol); hvol=refreshScreen(hvol); searchType =$2 ; outFileName='$3'; prfModels={'$4'}; rmMain(hvol,[],searchType,'matFileName', outFileName,'model',prfModels); quit();"


