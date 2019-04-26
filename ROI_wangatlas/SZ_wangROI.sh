#!/bin/bash
#Drawing probabilistic ROI 

########
#Docker to run the neurpythy command
########

# /usr/local/freesurfer/subjects is folder containing freesurfer directory for a subject eg: bert in this case
# /subjects after ':' is the directory of docker to which the subject's directory is mapped


export SUBJECTS_DIR_LOCAL=/mnt/storage_2/SZ/Nben_ROI/example_subject
export subjid=bert
 
#sudo docker run -ti --rm -v ${SUBJECTS_DIR_LOCAL}:/subjects nben/neuropythy atlas --verbose ${subjid}

#######
#Extracting wang atlas generated to convert into freesurfer label format
#######

export roiname_array=(1 "V1v" "V1d" "V2v" "V2d" "V3v" "V3d" "hV4" "VO1" "VO2" "PHC1" "PHC2" \
    "TO2" "TO1" "LO2" "LO1" "V3B" "V3A" "IPS0" "IPS1" "IPS2" "IPS3" "IPS4" \
    "IPS5" "SPL1" "FEF")


for i in {1..25}
do
 mri_cor2label --sd ${SUBJECTS_DIR_LOCAL} --i ${SUBJECTS_DIR_LOCAL}/${subjid}/surf/lh.wang15_mplbl.mgz --id ${i} --l lh.wang2015atlas.${roiname_array[${i}]}.label --surf ${subjid} lh inflated
 mri_cor2label --sd ${SUBJECTS_DIR_LOCAL} --i ${SUBJECTS_DIR_LOCAL}/${subjid}/surf/rh.wang15_mplbl.mgz --id ${i} --l rh.wang2015atlas.${roiname_array[${i}]}.label --surf ${subjid} rh inflated
done
