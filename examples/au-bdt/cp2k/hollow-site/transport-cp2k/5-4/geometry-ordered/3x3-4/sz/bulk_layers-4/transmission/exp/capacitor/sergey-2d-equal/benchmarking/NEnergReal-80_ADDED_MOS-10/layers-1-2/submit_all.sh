#! /bin/bash

for folder in */ ; do
	echo "$folder"
	cd $folder
	sbatch submit.slurm
	cd ..
done

