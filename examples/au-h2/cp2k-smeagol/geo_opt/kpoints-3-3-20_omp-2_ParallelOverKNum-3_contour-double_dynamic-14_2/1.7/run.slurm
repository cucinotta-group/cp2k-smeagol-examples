#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=3
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=2
#SBATCH --time=24:00:00
#SBATCH --account=e05-gc-clo
#SBATCH --partition=standard
#SBATCH --qos=standard

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
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl-fexternal-blas-limit/exe/local/cp2k.psmp
cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl-fexternal-blas-limit_double-contour/exe/local/cp2k.psmp

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
cp input/* .

kpoints_bulk="3 3 20"
kpoints_em="3 3 1"

sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3_0V.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  4_V.inp

#srun --hint=nomultithread --distribution=block:block $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
bulk_folder=/work/e05/e05/cahart/postdoc/transport/cp2k-smeagol-examples/au-h2/cp2k-smeagol/transmission/kpoints-3-3-20_omp-2_ParallelOverKNum-3_contour-single
cp $bulk_folder/*bulk* .

#srun --hint=nomultithread --distribution=block:block $cp2k -i 2_dft_wfn.inp -o log_2_dft_wfn.out
dft_folder=$bulk_folder
cp $dft_folder/*dft* .

HLB="$(grep '0.0000000000' bulk-VH_AV.dat | awk '{print $2}')"
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.inp

#srun --hint=nomultithread --distribution=block:block $cp2k -i 3_0V.inp -o log_3_0V.out
0V_folder=$bulk_folder
cp $dft_folder/*0V* .

V=1.7
echo $V
mv 4_V.inp 4_${V}V.inp
sed -i -e "s/PROJECT_REPLACE/${V}V/g" 4_${V}V.inp
sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_${V}V.inp
sed -i -e "s/V_REPLACE/${V}/g"  4_${V}V.inp

srun --hint=nomultithread --distribution=block:block $cp2k -i 4_${V}V.inp -o log_4_${V}V.out
