#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=2
#SBATCH --time=00:05:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=short

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cp2k/cp2k-2023.1

# CP2K 2023.1 Official recompiled
#cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1/exe/ARCHER2/cp2k.popt

# CP2K-SMEAGOL
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private/exe/local/cp2k.popt
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-sergey-1/exe/local/cp2k.popt
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1/exe/local/cp2k.popt
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl/exe/local/cp2k.psmp
cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl-fexternal-blas-limit/exe/local/cp2k.psmp
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl-fexternal-blas-limit_double-contour/exe/local/cp2k.psmp

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
cp input/* .

kpoints_bulk="2 2 20"
kpoints_em="2 2 1"

sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2-1_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2-2_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3-1_0V.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3-2_0V.inp

srun --hint=nomultithread --distribution=block:block $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
srun --hint=nomultithread --distribution=block:block $cp2k -i 2-1_dft_wfn.inp  -o log_2-1_dft_wfn.out
srun --hint=nomultithread --distribution=block:block $cp2k -i 2-2_dft_wfn.inp  -o log_2-2_dft_wfn.out

HLB="$(grep '0.0000000000' bulk-VH_AV.dat | awk '{print $2}')"
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3-1_0V.inp
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3-2_0V.inp

srun --hint=nomultithread --distribution=block:block $cp2k -i 3-1_0V.inp  -o log_3-1_0V.out
srun --hint=nomultithread --distribution=block:block $cp2k -i 3-2_0V.inp  -o log_3-2_0V.out

pot.sh
