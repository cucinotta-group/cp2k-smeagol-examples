#!/bin/bash


param_1=$(seq -2 0.5 2)
echo $param_1

job_directory=iv_curve
replace=V_REPLACE_JOB
job_file=run.slurm

rm energy.out

for ii in $param_1 ; do
        work_dir=$job_directory/V_${ii}
        grep 'Total F' $job_directory/V_${ii}/log_4_${ii}V.out | awk '{print $9}'
	grep 'Total F' $job_directory/V_${ii}/log_4_${ii}V.out | awk '{print $9}' >> energy.out
done

wait
