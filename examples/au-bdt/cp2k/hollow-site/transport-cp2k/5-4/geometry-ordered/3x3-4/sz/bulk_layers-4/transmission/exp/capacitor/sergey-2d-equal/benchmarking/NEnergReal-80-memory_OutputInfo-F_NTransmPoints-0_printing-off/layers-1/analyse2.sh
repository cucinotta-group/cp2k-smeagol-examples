#!/bin/bash

input=("log_1-bulkLR.out" "log_2_dft_wfn.out" "log_3_0V.out" "log_4_V.out")
output=("scf-log_1.out"  "scf-log_2.out" "scf-log_3.out"  "scf-log_4.out")

var_1=("1-1-20" "2-2-20" "4-4-20")
var_2=("20" "40" "80" "120")
grep_line="scf_env_do_scf_inner_loop"

for k in "${!input[@]}"; do
	rm ${output[$k]}

	for i in "${var_1[@]}"; do
		for j in "${var_2[@]}"; do
        
		file=kpoints-${i}_hlb-auto_cores-${j}/${input[$k]}
		echo "Analysing: $file"
		scf=5
		results="$(grep ' 0.30E+00 ' kpoints-${i}_hlb-auto_cores-${j}/${input[$k]} | awk '{print $4}'| awk '{ SUM += $1} END { print SUM }')"
		#results="$(grep "${grep_line}" kpoints-${i}_hlb-auto_cores-${j}/${input[$k]})"
		echo "$file $scf $results"  >> ${output[$k]}
	done
    done
done


