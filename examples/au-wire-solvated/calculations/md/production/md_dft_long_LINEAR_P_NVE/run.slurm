#!/bin/bash

#SBATCH --job-name=wire_dft
#SBATCH --nodes=2
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=long

# Add a line to the hirshfeld file to mark a restart (if it is a restart)
restart_fn=$(ls *-1.restart)
hirsh_file=$(ls *.hirshfeld)
if [ $? -eq 0 ]; then
        current=$(grep STEP_START $restart_fn | awk '{print $2}')
        date=$(date)
        echo "! =========== RESTART AT ${current} FRAMES ON ${date} ==============" >> $hirsh_file
fi

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cp2k/cp2k-2023.1

# Official
#cp2k=/work/y07/shared/apps/core/cp2k/cp2k-2023.1/exe/ARCHER2/cp2k.psmp

# CP2K 2023.1 Official recompiled
#cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1/exe/ARCHER2/cp2k.popt

# CP2K-SMEAGOL
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private/exe/local/cp2k.popt
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-sergey-1/exe/local/cp2k.popt
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1/exe/local/cp2k.popt
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl/exe/local/cp2k.psmp
cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl-fexternal-blas-limit/exe/local/cp2k.psmp
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-chris-1-forge-mkl-fexternal-blas-limit_double-contour/exe/local/cp2k.psmp

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MKL_NUM_THREADS=$SLURM_CPUS_PER_TASK
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

#find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
#cp input/* .

kpoints_bulk="1 1 20"
kpoints_em="1 1 1"
sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3_0V.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  4_V.inp

srun --hint=nomultithread --distribution=block:block $cp2k -i 2_dft_wfn.inp -o log_2_dft_wfn.out

TARGET=5000
restart_fn=$(ls *-1.restart)

current=$(grep STEP_START_VAL $restart_fn | awk '{print $2}')
echo $current

if [ $current -le $TARGET ]; then
        # Resubmit!
        echo 'resubmit'
        cp $restart_fn 2_dft_wfn.inp
        sbatch run.slurm
fi
