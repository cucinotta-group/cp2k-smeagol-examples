#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=2
#SBATCH --tasks-per-node=32
#SBATCH --cpus-per-task=4
#SBATCH --time=04:00:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

module load PrgEnv-gnu
module load mkl
module load cray-fftw
module load cray-python
module load cp2k/cp2k-2023.1

# ARM FORGE MAP
module load arm/forge
source ${FORGE_DIR}/config-init

# CP2K must be compiled with additional libriaries, see https://docs.archer2.ac.uk/data-tools/arm-forge/
#cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1-updated/cp2k-2023.1-recompiled2/exe/ARCHER2/cp2k.psmp
cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-sergey-2/exe/local/cp2k.psmp

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=4
export MKL_NUM_THREADS=4
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
cp input/* .

kpoints_bulk="1 1 20"
kpoints_em="1 1 1"

sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3_0V.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  4_V.inp

cores=64

srun --hint=nomultithread --distribution=block:block $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
#srun --hint=nomultithread --distribution=block:block $cp2k  -i 2_dft_wfn.inp -o log_2_dft_wfn.out

#map -n $cores --mpi=slurm  --mpiargs="--hint=nomultithread --distribution=block:block " --profile $cp2k  -i 1_bulkLR.inp -o log_1-bulkLR.out
map -n $cores --mpi=slurm  --mpiargs="--hint=nomultithread --distribution=block:block " --profile $cp2k  -i 2_dft_wfn.inp -o log_2_dft_wfn.out

HLB="$(grep '0.0000000000' bulk-VH_AV.dat | awk '{print $2}')"
echo $HLB
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.inp
sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_V.inp

map -n $cores --mpi=slurm  --mpiargs="--hint=nomultithread --distribution=block:block " --profile $cp2k  -i 3_0V.inp -o log_3_0V.out
map -n $cores --mpi=slurm  --mpiargs="--hint=nomultithread --distribution=block:block " --profile $cp2k  -i  4_V.inp -o log_4_V.out
