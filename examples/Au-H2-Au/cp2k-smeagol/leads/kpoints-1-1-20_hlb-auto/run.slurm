#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cray-fftw

# CP2K 2023.1 Official recompiled
#cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1/exe/ARCHER2/cp2k.popt

# CP2K-SMEAGOL
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private/exe/local/cp2k.popt
cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-sergey-1/exe/local/cp2k.popt
#p2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1/exe/local/cp2k.popt

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

kpoints_bulk="1 1 20"
kpoints_em="1 1 1"

sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp
#sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2_dft_wfn.inp
#sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3_0V.inp
#sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  4_V.inp

srun --hint=nomultithread --distribution=block:block $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
#srun --hint=nomultithread --distribution=block:block $cp2k -i 2_dft_wfn.inp -o log_2_dft_wfn.out

#HLB="$(grep '0.0000000000' bulk-VH_AV.dat | awk '{print $2}')"
#sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.inp

#srun --hint=nomultithread --distribution=block:block $cp2k -i 3_0V.inp -o log_3_0V.out

#HLB="$(grep '0.0000000000' bulk-VH_AV.dat | awk '{print $2}')"
#V=1
#sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_V.inp
#sed -i -e "s/V_REPLACE/${V}/g"  4_V.inp

#srun --hint=nomultithread --distribution=block:block $cp2k -i 4_V.inp -o log_4_V.out
