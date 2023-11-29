#!/bin/sh

#SBATCH -n 4
#SBATCH -t 7:30:00
##SBATCH -U physics
#SBATCH -U HPC_12_00447
#SBATCH -p compute
#SBATCH -J freq-5.0
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/h2/5.0/freq

cd $dir
mpirun ~/software/smeagol-1.2-dev/Src/smeagol-1.2 <mol.fdf >mol.log


echo "Done."
