#!/bin/sh

#SBATCH -n 8
#SBATCH -t 0:30:00
##SBATCH -U physics
#SBATCH -U HPC_12_00447
#SBATCH -p debug
#SBATCH -J bader
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.0/800/opt

cd $dir
~/software/bader/bader 0.mx.cube >bader.log


echo "Done."
