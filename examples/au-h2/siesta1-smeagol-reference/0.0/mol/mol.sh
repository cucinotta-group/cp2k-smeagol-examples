#!/bin/sh

#SBATCH -n 2
#SBATCH -t 0:30:00
#SBATCH -U physics
#SBATCH -p debug
#SBATCH -J  mol
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.0/800/mol

cd $dir
mpirun ~/software/smeagol-1.2-coop/Src/smeagol-1.2-coop <mol.fdf >mol.log


echo "Done."
