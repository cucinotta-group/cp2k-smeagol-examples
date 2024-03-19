#!/bin/bash

lateral="4 6 8 10 12"

input_file=Au_junction.inp 
output_file=Au_junction.out  
plot_TotEn=layers_TotEn.dat
plot_FEn=layers_FEn.dat
plot_Relax=layers_relax.dat
 
basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=3
Ky=3
Kz=1
cutoff=500
rel_cutoff=40
 
echo "# N_layers vs total energy" > $plot_TotEn
echo "# Date: $(date)" >> $plot_TotEn
echo "# PWD: $PWD" >> $plot_TotEn
echo "# BASIS SET = $basis_set" >> $plot_TotEn
echo "# K-POINTS = ${Kx}x${Ky}x${Kz}" >> $plot_TotEn
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_TotEn
echo "# CUTOFF = $cutoff" >> $plot_TotEn
echo -n "# Lateral (NxNx1) | Total Energy (Ha) | Total Energy (eV) | Total Energy Elec (Ha) | Total Energy Elec (eV) | Total Energy Wire (Ha) | Total Energy Wire (eV) " >> $plot_TotEn

printf "\n" >> $plot_TotEn 

for ii in $lateral ; do
    work_dir=lateral_${ii}
    Elec_dir=elec
    Wire_dir=wire

    en_H=$(grep -e '^[ \t]*Total energy' $work_dir/$output_file | tail -n1 | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    en_elec_H=$(grep -e '^[ \t]*Total energy' $work_dir/$Elec_dir/$output_file | tail -n1 | awk '{print $3}')
    en_elec_eV=$( bc -l <<< "( $en_elec_H * 27.2114 )")
    en_wire_H=$(grep -e '^[ \t]*Total energy' $work_dir/$Wire_dir/$output_file | tail -n1 | awk '{print $3}')
    en_wire_eV=$( bc -l <<< "( $en_wire_H * 27.2114 )")
    
    printf "%10.2f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f" $ii $en_H $en_eV $en_elec_H $en_elec_eV $en_wire_H $en_wire_eV >> $plot_TotEn
    
    printf "\n" >> $plot_TotEn
done

echo "# Grid N_layers vs Fermi energy" > $plot_FEn
echo "# Date: $(date)" >> $plot_FEn
echo "# PWD: $PWD" >> $plot_FEn
echo "# BASIS SET = $basis_set" >> $plot_FEn
echo "# K-POINTS = ${Kx}x${Ky}x${Kz}" >> $plot_FEn
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_FEn
echo "# CUTOFF = $cutoff" >> $plot_FEn
echo -n "# Lateral (NxNx1) | Fermi Energy (Ha) | Fermi Energy (eV) | Fermi Energy Elec (Ha) | Fermi Energy Elec (eV) | Fermi Energy Wire (Ha) | Fermi Energy Wire (eV) " >> $plot_FEn

printf "\n" >> $plot_FEn

for ii in $lateral ; do
    work_dir=lateral_${ii}
    Elec_dir=elec
    Wire_dir=wire

    en_H=$(grep -e '^[ \t]*Fermi energy' $work_dir/$output_file | tail -n1 | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
    en_elec_H=$(grep -e '^[ \t]*Fermi energy' $work_dir/$Elec_dir/$output_file | tail -n1 | awk '{print $3}')
    en_elec_eV=$( bc -l <<< "( $en_elec_H * 27.2114 )")
    en_wire_H=$(grep -e '^[ \t]*Fermi energy' $work_dir/$Wire_dir/$output_file | tail -n1 | awk '{print $3}')
    en_wire_eV=$( bc -l <<< "( $en_wire_H * 27.2114 )")

    printf "%10.2f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f" $ii $en_H $en_eV $en_elec_H $en_elec_eV $en_wire_H $en_wire_eV >> $plot_FEn

    printf "\n" >> $plot_FEn

    done
