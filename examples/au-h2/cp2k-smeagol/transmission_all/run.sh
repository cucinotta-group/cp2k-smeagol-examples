#!/bin/bash

param_1="0.0 0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5 1.7 1.9"

#job_directory="kpoints-3-3-20_omp-2_ParallelOverKNum-9_contour-single"
job_directory="kpoints-3-3-20_omp-2_ParallelOverKNum-9_contour-single_dynamic-14"

replace=V_REPLACE_JOB
job_file=run.slurm
template_folder=template

if [ -d $job_directory ] ; then
	rm -r $job_directory
fi
mkdir $job_directory

for ii in $param_1 ; do
                work_dir=$job_directory/${ii}
                if [ -d $work_dir ] ; then
                        rm -r $work_dir
                fi

                cp -r $template_folder $work_dir

                sed -i -e "s/${replace}/${ii}/g" $work_dir/$job_file

done

for ii in $param_1 ; do
                work_dir=$job_directory/${ii}

                cd $work_dir
                sbatch $job_file
                cd ../..
done

wait
