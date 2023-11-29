#!/bin/sh

#SBATCH -n 48
#SBATCH -t 21:00:00
#SBATCH -U physics
#SBATCH -p compute
#SBATCH -J opt-1.7
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/AuH2/positive/1.7/opt

cd $dir
mpirun ~/software/smeagol-1.2-dev/Src/smeagol-1.2.exe <mx.fdf >mx.log


echo "Done."
