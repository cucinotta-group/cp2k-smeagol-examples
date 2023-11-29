#!/bin/bash

for folder in omp*/; do
        echo $folder
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
