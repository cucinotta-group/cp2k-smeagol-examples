#!/bin/sh

#SBATCH -n 2
#SBATCH -t 0:30:00
##SBATCH -U physics
#SBATCH -U HPC_12_00447
#SBATCH -p debug
#SBATCH -J coop
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/h2/chain

cd $dir
mpirun ~/software/siesta-3.1/Obj/siesta <lead.fdf >lead.log


echo "Done."
