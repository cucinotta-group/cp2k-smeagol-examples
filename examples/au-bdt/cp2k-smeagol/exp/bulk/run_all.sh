#!/bin/bash

for folder in */; do
        echo $folder
	cp -r kpoints-1-1-20/input  $folder/
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
