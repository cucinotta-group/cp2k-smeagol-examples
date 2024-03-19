#!/bin/bash

layers="3 4 5 6 7 8 9 10 11 12 13 14 15"

input_file=Au_slab.inp 
output_file=Au_slab.out  
plot_TotEn=layers_TotEn.dat
plot_FEn=layers_FEn.dat
 
basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=8
Ky=8
Kz=1
cutoff=350
rel_cutoff=40
 
echo "# N_layers vs total energy" > $plot_TotEn
echo "# Date: $(date)" >> $plot_TotEn
echo "# PWD: $PWD" >> $plot_TotEn
echo "# BASIS SET = $basis_set" >> $plot_TotEn
echo "# K-POINTS = ${Kx}x${Ky}x${Kz}" >> $plot_TotEn
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_TotEn
echo "# CUTOFF = $cutoff" >> $plot_TotEn
echo -n "# Layers | Total Energy (Ha) | Total Energy (eV) " >> $plot_TotEn

printf "\n" >> $plot_TotEn 

for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN

    en_H=$(grep -e '^[ \t]*Total energy' $work_dir/$EN_dir/$output_file | tail -n1 | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    
    printf "%10.2f %15.10f %15.10f" $ii $en_H $en_eV >> $plot_TotEn
    
    printf "\n" >> $plot_TotEn
done

echo "# Grid N_layers vs Fermi energy" > $plot_FEn
echo "# Date: $(date)" >> $plot_FEn
echo "# PWD: $PWD" >> $plot_FEn
echo "# BASIS SET = $basis_set" >> $plot_FEn
echo "# K-POINTS = ${Kx}x${Ky}x${Kz}" >> $plot_FEn
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_FEn
echo "# CUTOFF = $cutoff" >> $plot_FEn
echo -n "# Layers | Fermi Energy (Ha) | Fermi energy (eV) " >> $plot_FEn

printf "\n" >> $plot_FEn

for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN

    en_H=$(grep -e '^[ \t]*Fermi energy' $work_dir/$EN_dir/$output_file | tail -n1 | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    
    printf "%10.2f %15.10f %15.10f" $ii $en_H $en_eV >> $plot_FEn
    
    printf "\n" >> $plot_FEn
done

