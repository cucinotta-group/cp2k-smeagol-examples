#!/bin/bash
 
#Kpoints="2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"
Kpoints="2 4 6 8 10 12 14 16 18"
input_file=input.inp
output_file=log.out
plot_TotEn=output_kpoints.dat

rm $plot_TotEn 
for ii in $Kpoints ; do
    work_dir=Kpoints_${ii}

    en_H=$(grep -e '^[ \t]*Total energy' $work_dir/$output_file | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    time=$(grep 'CP2K   ' $work_dir/$output_file  | awk '{print $6}')

    printf "%10.2f %15.10f %15.10f %10.2f" $ii $en_H $en_eV $time >> $plot_TotEn
    
    printf "\n" >> $plot_TotEn
done


