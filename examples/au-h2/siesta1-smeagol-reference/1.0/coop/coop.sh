#!/bin/sh

#SBATCH -n 32
#SBATCH -t 6:00:00
#SBATCH -U physics
#SBATCH -p compute
#SBATCH -J coop-1.0
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/1.0/800/coop

cd $dir
mpirun ~/software/smeagol-1.2-coop/Src/smeagol-1.2-coop <mx.fdf >mx.log


echo "Done."
