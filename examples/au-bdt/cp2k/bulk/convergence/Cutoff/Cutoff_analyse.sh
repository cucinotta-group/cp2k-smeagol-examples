#!/bin/bash
 
cutoffs="50 100 150 200 250 300 350 400 450 500 550 600 650 700"

input_file=input.inp
output_file=log.out
plot_TotEn=output_cutoff.dat
 
rm $plot_TotEn
for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry

    en_H=$(grep -e '^[ \t]*Total energy' $work_dir/$output_file | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    time=$(grep 'CP2K   ' $work_dir/$output_file  | awk '{print $6}') 
    
    printf "%10.2f %15.10f %15.10f %10.2f" $ii $en_H $en_eV $time >> $plot_TotEn
    
    printf "\n" >> $plot_TotEn
done


