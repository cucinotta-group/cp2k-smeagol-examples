#!/bin/bash

for folder in */; do
        echo $folder
	#cp -r md_dft_standard/input  $folder/
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
