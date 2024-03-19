#!/bin/bash

TARGET=5000
restart_fn=$(ls *-1.restart)
current=$(grep STEP_START_VAL $restart_fn | awk '{print $2}')
echo $current

if [ $current -le $TARGET ]; then
        # Resubmit!
        echo 'resubmit'
       cp $restart_fn 2_dft_wfn.inp
       	sbatch run.slurm
fi
