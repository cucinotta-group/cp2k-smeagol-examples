#!/bin/sh

#SBATCH -n 36
#SBATCH -t 11:00:00
##SBATCH -U physics
#SBATCH -U HPC_12_00448
#SBATCH -p compute
#SBATCH -J freq-0.0
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.0/800/freq/less

cd $dir
mpirun ~/software/smeagol-1.2-dev/Src/smeagol-1.2 <mx.fdf >mx.log


echo "Done."
