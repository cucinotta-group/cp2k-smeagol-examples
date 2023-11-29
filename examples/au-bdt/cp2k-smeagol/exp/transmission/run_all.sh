#!/bin/bash

for folder in */; do
        echo $folder
	cp -r kpoints-4-4-100/input  $folder/
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
