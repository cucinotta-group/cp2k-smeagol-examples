#!/bin/sh

#SBATCH -n 8
#SBATCH -t 11:30:00
##SBATCH -U HPC_12_00447 
#SBATCH -U physics
#SBATCH -p compute
#SBATCH -J proj
#srun hostname

#. ~/.bashrc
#. /etc/profile.d/modules.sh
#module load intel/cc/64/11.0.074
#module load intel/fc/64/11.0.074
#module load intel/11.0.074/openmpi/64/1.3.3


# Set the stack size to unlimited.
ulimit -s unlimited
export KMP_STACKSIZE=9999999999
export OMP_NUM_THREADS=8
export MKL_NUM_THREADS=8

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias/0.0/800/proj

cd $dir
acmoc <input.fdf >out.log

echo "Done."
