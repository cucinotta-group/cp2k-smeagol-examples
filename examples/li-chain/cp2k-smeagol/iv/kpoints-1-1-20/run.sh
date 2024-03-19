#!/bin/bash


param_1=$(seq -2 0.5 2)
echo $param_1

job_directory=iv_curve
replace=V_REPLACE_JOB
job_file=run.slurm

if [ -d $job_directory ] ; then
	rm -r $job_directory
fi
mkdir $job_directory

for ii in $param_1 ; do

		cd $job_directory
		echo ${ii}
		work_dir=V_${ii}
		if [ -d $work_dir ] ; then
			rm -r $work_dir
		fi

		cp -r ../template $work_dir
		cd $work_dir
		
		sed -i -e "s/${replace}/${ii}/g"  $job_file

		cd ../..
done

wait

for ii in $param_1 ; do
		work_dir=$job_directory/V_${ii}
		cd $work_dir
		sbatch $job_file
		cd ../..
done

wait

