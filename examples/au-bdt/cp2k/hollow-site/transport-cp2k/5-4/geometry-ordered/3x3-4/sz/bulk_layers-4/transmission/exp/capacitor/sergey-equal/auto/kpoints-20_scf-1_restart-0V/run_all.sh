#! /bin/bash

for d in */ ; do
	echo $d
	cd $d
	sed -i -e "s/24:00:00/01:00:00/g"  submit.slurm
	sed -i -e "s/WFN_RESTART_FILE_NAME dft_wfn-RESTART_0.kp/WFN_RESTART_FILE_NAME 0V-RESTART_0.kp/g"  input/3_0V.inp
	#cp ../submit.slurm .
	sbatch submit.slurm
	cd ..
done
