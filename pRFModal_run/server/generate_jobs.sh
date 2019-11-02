#!/bin/bash

index=1
for n_hemi in `seq 1 14`
do
    for n_stim in `seq 1 1`
   do
	for n_roi in `seq 1 6` 
	do
	    cat template.pbs > mcmc_tiny_${n_hemi}_${n_stim}_${n_roi}.pbs
	    sed -i -e "s/n_hemi/$n_hemi/g" mcmc_tiny_${n_hemi}_${n_stim}_${n_roi}.pbs
	    sed -i -e "s/n_stim/$n_stim/g" mcmc_tiny_${n_hemi}_${n_stim}_${n_roi}.pbs
	    sed -i -e "s/n_roi/$n_roi/g" mcmc_tiny_${n_hemi}_${n_stim}_${n_roi}.pbs
	    sed -i -e "s/index/$index/g" mcmc_tiny_${n_hemi}_${n_stim}_${n_roi}.pbs

	    
	    qsub mcmc_tiny_${n_hemi}_${n_stim}_${n_roi}.pbs
	    let "index=$index + 1"
	    
	done
    done
done
