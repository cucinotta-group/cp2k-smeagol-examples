#!/bin/sh

#SBATCH -n 8
#SBATCH -t 8:30:00
#SBATCH -U physics
##SBATCH -U HPC_12_00447
#SBATCH -p compute
#SBATCH -J cube-gen
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias

for i in `ls -d [0-9]*`;do
cd $dir/$i/800/opt
mv 0.mx.RHO mx.RHO
/home/users/baim/software/siesta-3.1/Util/Grid/grid2cube <inp.txt
~/software/bader/bader mx.RHO.cube >bader.log
done


echo "Done."
