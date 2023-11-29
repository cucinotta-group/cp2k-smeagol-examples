#!/bin/sh

#SBATCH -n 1
#SBATCH -t 0:30:00
##SBATCH -U physics
#SBATCH -U HPC_12_00447
#SBATCH -p debug
#SBATCH -J cube-gen
#srun hostname



# Set the stack size to unlimited.
ulimit -s unlimited

dir=/home/users/baim/workspace/MD/gold/3d/100/jp/spd/newbasis/bias

for i in 1.6  1.7  1.8  1.9;do
cd $dir
~/software/siesta-2.0.2/Util/Sies2xsf-Latest/rho2cube_keep $i/800/opt mx RHO 0 0.05
mv $i/800/opt/0.mx.cube /gscratch/pi-ssanvito/baim/$i.cube
done


echo "Done."
