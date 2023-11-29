#!/bin/bash

for folder in omp*/; do
        echo $folder
	cp -r  bulk/input $folder/
	cd $folder
	cd ..
done

wait

for folder in omp*/; do
        echo $folder
        cd $folder
        rm slurm-*; sbatch run.slurm
        cd ..
done
