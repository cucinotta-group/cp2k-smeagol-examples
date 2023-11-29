#!/bin/sh

#SBATCH -n 48
#SBATCH -t 23:00:00
#SBATCH -U physics
#SBATCH -p compute
#SBATCH -J freq-0.7
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.7/800/freq

cd $dir
mpirun ~/software/smeagol-1.2-dev/Src/smeagol-1.2 <mx.fdf >mx.log


echo "Done."
