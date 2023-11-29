#!/bin/bash

for folder in omp*/; do
        echo $folder
	cp -r  bulk/input $folder/
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
