#!/bin/bash
  
#SBATCH --job-name=siesta
#SBATCH --nodes=1
#SBATCH --tasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

module load gcc/11.2.0
module load PrgEnv-gnu/8.3.3
module load mkl
module load cray-fftw
module load cray-python
module load arm/forge
module load craype-network-ucx
module load cray-mpich-ucx

# SIESTA+SMEAGOL Ivan
#smeagol=/work/e05/e05/cahart/smeagol/siesta-smeagol-gnu/Src/smeagol-1.2_csg
smeagol=/work/e05/e05/cahart/smeagol/smeagol-ivan/siesta-smeagol-openmp-2/Src/smeagol-1.2_csg

# SIESTA+SMEAGOL Alex
#smeagol=/work/e05/e05/cahart/smeagol/smeagol-alex/siesta-alex-gnu/Obj/smeagol_alex
#smeagol=/work/e05/e05/cahart/smeagol/smeagol-alex/siesta-alex-gnu2/Obj/smeagol_alex
#smeagol=/work/e05/e05/cahart/smeagol/smeagol-alex/siesta-alex-gnu-openmp/Obj/smeagol_alex

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
cp input/* .

# Replace kpoints in all files
kpoints_bulk="20"
kpoints_em="3"
#sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  1_bulkLR.fdf
#sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  2_dft_wfn.fdf
#sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  3_0V.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g" 4_V.fdf
#sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  1_bulkLR.fdf
#sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  2_dft_wfn.fdf
#sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  3_0V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  4_V.fdf

#srun --hint=nomultithread --distribution=block:block $smeagol  <1_bulkLR.fdf > log_1_bulkLR.out 2>err_1_bulkLR.out
#export PATH=$PATH:/work/e05/e05/cahart/smeagol/Smeagol_Tutorial/Smeagol_Tutorial_Files/bin:$PATH
#pot.sh

bulk_folder=/work/e05/e05/cahart/postdoc/transport/AuH2/siesta-smeagol-ivan/leads/kpoints-3-3-20_hlb-auto_cores-64
cp $bulk_folder/*bulk* .
cp $bulk_folder/*lead* .

HLB="$(grep '0.000  '  0.bulk-VH_AV.dat | awk '{print $2}')"
#sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.fdf
sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_V.fdf

#srun --hint=nomultithread --distribution=block:block $smeagol  <2_dft_wfn.fdf > log_2_dft_wfn.out 2>err_2_dft_wfn.out
#srun --hint=nomultithread --distribution=block:block $smeagol  <3_0V.fdf > log_3_0V.out 2>err_3_0V.out

#V=1
#sed -i -e "s/V_REPLACE/${V}/g"  4_V.fdf
srun --hint=nomultithread --distribution=block:block $smeagol  <4_V.fdf > log_4_V.out 2>err_4_V.out
