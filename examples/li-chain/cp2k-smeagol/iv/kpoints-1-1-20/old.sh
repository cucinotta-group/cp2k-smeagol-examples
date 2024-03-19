#!/bin/bash

param_1=$(seq -2 0.5 2)
echo $param_1

job_directory=iv_curve
output_file=IV.log

rm $output_file
echo "IV curve" > $output_file

for ii in $param_1 ; do
		work_dir=$job_directory/V_${ii}
		
		charge="$(grep 'Total Charge' iv_curve/V_${ii}/log_4_${ii}V.out | awk '{print $3}')"
		scf="$(grep 'scf_env_do_scf_inner_loop' iv_curve/V_${ii}/log_4_${ii}V.out | awk '{print $2}')"
		current="$(cat $work_dir/${ii}V.CUR | awk '{print $2}')"
		echo "${ii} $current $charge $scf"  >> $output_file

done

sed -i -e "s/D/E/g"  $output_file

wait

