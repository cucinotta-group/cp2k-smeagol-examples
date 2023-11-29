#!/bin/sh

#SBATCH -n 8
#SBATCH -t 8:00:00
#SBATCH -U physics
#SBATCH -p compute
#SBATCH -J ldos-0.0
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.0/800/ldos/m0.6

cd $dir
mpirun ~/software/smeagol-1.2-dev/Src/smeagol-1.2 <mx.fdf >mx.log


echo "Done."
