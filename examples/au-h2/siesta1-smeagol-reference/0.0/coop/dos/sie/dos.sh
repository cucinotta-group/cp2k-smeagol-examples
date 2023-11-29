#!/bin/sh

#SBATCH -n 8
#SBATCH -t 4:00:00
#SBATCH -U physics
#SBATCH -p compute
#SBATCH -J coop-0.0
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.0/800/coop/dos/sie

cd $dir
mpirun ~/software/siesta-3.1/Obj/siesta <mx.fdf >mx.log


echo "Done."
