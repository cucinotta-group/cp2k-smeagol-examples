#! /bin/bash

for d in */ ; do
	echo $d
	cd $d
	sed -i -e "s/ATOMIC/RESTART/g"  submit.slurm
	#cp ../submit.slurm .
	sbatch submit.slurm
	cd ..
done
