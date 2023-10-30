#!/bin/bash

#param_1="0.0 0.1 0.3 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.45 1.5 1.55 1.6 1.7 1.8 1.9"
param_1="0.0 0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5 1.7 1.9"
#param_1="0.0"
job_directory="NEnergReal-64_kpoints-3-3-20_omp-2_ParallelOverKNum-3_scf-1e-6_EXTRAPOLATION-USE_PREV_P"
input_file=4_V.inp 
job_file=run.slurm
template_folder=template


for ii in $param_1 ; do
                work_dir=$job_directory/${ii}
                if [ -d $work_dir ] ; then
                        rm -r $work_dir
                fi

                cp -r $template_folder $work_dir

                sed -i -e "s/V_REPLACE/${ii}/g" \
                        $work_dir/input/$input_file

done

for ii in $param_1 ; do
                work_dir=$job_directory/${ii}

                cd $work_dir
                sbatch $job_file
                cd ../..
done

wait
