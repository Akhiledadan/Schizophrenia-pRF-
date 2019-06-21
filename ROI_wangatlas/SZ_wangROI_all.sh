#!/bin/bash/

python -m neuropythy atlas --verbose $1/    #<subjid> is the subject fodler name containing the freesurfer files

####################################
# converting Wang et al labels to mrVista compatible labels
####################################


# Convert the left and right surface ROI files to volume files


python -m neuropythy surface_to_image -m nearest -l /home/p266162/data/25042019/freesurfer/$1/surf/lh.wang15_mplbl.mgz -r /home/p266162/data/25042019/freesurfer/$1/surf/rh.wang15_mplbl.mgz $1 /home/p266162/data/25042019/freesurfer/$1/mri/native.wang2015_atlas.mgz
