#!/bin/bash

for folder in omp*/; do
        echo $folder
	cp -r  bulk_dft/input $folder/
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
