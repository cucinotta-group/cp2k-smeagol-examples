#! /bin/bash

for d in */ ; do
	echo $d
	cd $d
	#cp ../submit.slurm .
	sbatch submit.slurm
	cd ..
done
