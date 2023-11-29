#!/bin/bash

var_1=("1" "2" "4" "8" "16"  "32" "64")  
grep_line_1="1 NoMix"
grep_line_2="2 Broy"
grep_line_3="MEMORY| Estimated peak process memory"
output=log.out

rm $output

file_dft=dft/log_2_dft_wfn.out
time_dft_1="$(grep "${grep_line_1}" $file_dft | awk '{print $4}')"
time_dft_2="$(grep "${grep_line_2}" $file_dft | awk '{print $4}')"
memory_dft="$(grep "${grep_line_3}" $file_dft | awk '{print $7}')"
echo "$file_dft  $time_dft_1"  >> $output
echo "$file_dft  $time_dft_2"  >> $output
echo "$file_dft  $memory_dft"  >> $output

for i in "${var_1[@]}"; do

	file_0V=omp-${i}_V-0/log_3_0V.out
	file_1V=omp-${i}_V-1/log_4_1V.out
	echo "Analysing: $file_0V"
	echo "Analysing: $file_1V"

	time_0V_1="$(grep "${grep_line_1}" $file_0V | awk '{print $4}')"
	time_0V_2="$(grep "${grep_line_2}" $file_0V | awk '{print $4}')"
	memory_0V="$(grep "${grep_line_3}" $file_0V | awk '{print $7}')"

	time_1V_1="$(grep "${grep_line_1}" $file_1V | awk '{print $4}')"
	time_1V_2="$(grep "${grep_line_2}" $file_1V | awk '{print $4}')"
	memory_1V="$(grep "${grep_line_3}" $file_1V | awk '{print $7}')"
	echo "$file_0V  $time_0V_1"  >> $output
	echo "$file_0V  $time_0V_2"  >> $output
	echo "$file_0V  $memory_0V"  >> $output
	echo "$file_1V  $time_1V_1"  >> $output
	echo "$file_1V  $time_1V_2"  >> $output
	echo "$file_1V  $memory_1V"  >> $output

done
