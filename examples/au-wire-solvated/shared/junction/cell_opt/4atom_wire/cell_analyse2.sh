#!/bin/bash

input_file=Au_junction.inp 
output_file=Au_junction.out  
plot_TotEn=layers_TotEn.dat
plot_FEn=layers_FEn.dat
 
basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=4
Ky=4
Kz=1
cutoff=500
rel_cutoff=40
 
echo "# Iterations vs Total Energy" > $plot_TotEn
echo "# Date: $(date)" >> $plot_TotEn
echo "# PWD: $PWD" >> $plot_TotEn
echo "# BASIS SET = $basis_set" >> $plot_TotEn
echo "# K-POINTS = ${Kx}x${Ky}x${Kz}" >> $plot_TotEn
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_TotEn
echo "# CUTOFF = $cutoff" >> $plot_TotEn
echo -n "#  Iterations | Z Cell Size (A) | Total Energy (eV) " >> $plot_TotEn

printf "\n" >> $plot_TotEn 

    work_dir=cell_6i
    output2_file=Au_junction-pos-1.xyz

    x=$(grep 'i' $work_dir/$output2_file | tail -n1 | tr -d '[=,=]'| awk '{print $3}')

    for ii in `seq 1 $x` ; do
    restart_file=Au_junction-1_${ii}.restart	    
    en_H=$(grep -e 'E' $work_dir/$output2_file | head -${ii} | tail -n1 | awk '{print $6}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    Z_size=$(grep " C " $work_dir/$restart_file | awk '{print $4}')
    
    printf "%15.0f %15.10f %15.10f" $ii $Z_size $en_eV >> $plot_TotEn
    
    printf "\n" >> $plot_TotEn
done

