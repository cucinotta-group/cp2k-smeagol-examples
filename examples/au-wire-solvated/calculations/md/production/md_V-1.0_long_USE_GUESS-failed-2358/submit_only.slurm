#!/bin/bash

V=1.0
TARGET=5000
restart_fn=$(ls *-1.restart)
current=$(grep STEP_START_VAL $restart_fn | awk '{print $2}')
echo $current

if [ $current -le $TARGET ]; then
        # Resubmit!
        echo 'resubmit'
       	cp $restart_fn 4_${V}V.inp
	sbatch run.slurm
fi
