#!/bin/bash

if [ -z "$1" ]
then
 echo 'Run_mprf_model. Inputs:'
 echo 'mrSESSION directory=$1, path to the folder containing mrSESSION.mat' 
 exit 1
fi

cd $1 

Applications/MATLAB_R2014b.app/. matlab -nodesktop -nosplash -nojvm -nodisplay -r "addpath(genpath('/Volumes/Marouska/pRFallfiles/pRF_Analysis/pRF_code/')); FileName = [];prfModels = {'one gaussian'};searchType = 3;outFileName = 'SZ_2DGaussian';rmMain(VOLUME{1},[],searchType,'matFileName', outFileName,'model',prfModels); quit();"


