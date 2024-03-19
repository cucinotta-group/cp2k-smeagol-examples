#!/bin/bash

layers="3 4 5 6 7 8 9 10 11 12 13 14 15 16"
layers2="5 6 7 8 9 10 11 12 13 14 15 16"

input_file=Au_slab.inp 
output_file=Au_slab.out  
plot_TotEn=layers_TotEn.dat
plot_FEn=layers_FEn.dat
plot_Relax=layers_relax.dat
 
basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=12
Ky=12
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

echo "# Layers vs Relaxation" > $plot_Relax
echo "# Date: $(date)" >> $plot_Relax
echo "# PWD: $PWD" >> $plot_Relax
echo "# BASIS SET = $basis_set" >> $plot_Relax
echo "# CUTOFF = $cutoff" >> $plot_Relax
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_Relax
echo -n "# Layers | Z_1 (A) | delta_12 (%) | delta_23 (%) | delta_34 (%) " >> $plot_Relax
#echo -n "# Layers | Z_1 (A) | delta_12 (%) | delta_23 (%) | delta_34 (%) " >> $plot_Relax

printf "\n" >> $plot_Relax

for ii in $layers2 ; do
    work_dir=layers_${ii}
    EN_dir=EN
    trajectory_file=Au_slab-pos-1.xyz

    atoms=$(grep -m1 "" $work_dir/$trajectory_file | tr -dc '0-9')
    lay=$(bc -l <<< "$atoms/4")
    layers=$( printf "%.0f" $lay )
    d0=2.40131524

   # for i in {1..3} ; 

           # xi=$(bc -l <<< "16 - 4*$i")
           # Z_$i=$(grep -e 'Au' $work_dir/$trajectory_file | tail -$xi | head -4 | awk 'BEGIN{sum=0; count=0}{sum+=$4; count+=1}END{print sum/count}')
	   arg1=$( bc -l <<< "4*$ii")
	   arg2=$( bc -l <<< "4*$ii - 4")
	   arg3=$( bc -l <<< "4*$ii - 8")
	   arg4=$( bc -l <<< "4*$ii - 12")
           Z_1=$(grep -e 'Au' $work_dir/$trajectory_file | tail -$arg1 | head -4 | awk 'BEGIN{sum=0; count=0}{sum+=$4; count+=1}END{printf "%15.10f", sum/count}')
           Z_2=$(grep -e 'Au' $work_dir/$trajectory_file | tail -$arg2 | head -4 | awk 'BEGIN{sum=0; count=0}{sum+=$4; count+=1}END{printf "%15.10f", sum/count}')
           Z_3=$(grep -e 'Au' $work_dir/$trajectory_file | tail -$arg3 | head -4 | awk 'BEGIN{sum=0; count=0}{sum+=$4; count+=1}END{printf "%15.10f", sum/count}')
           Z_4=$(grep -e 'Au' $work_dir/$trajectory_file | tail -$arg4 | head -4 | awk 'BEGIN{sum=0; count=0}{sum+=$4; count+=1}END{printf "%15.10f", sum/count}')
           delta_12=$(bc -l <<< "($Z_2 - $Z_1 - (2-1)*$d0)*100/$d0")
           delta_23=$(bc -l <<< "($Z_3 - $Z_2 - (3-2)*$d0)*100/$d0")
           delta_34=$(bc -l <<< "($Z_4 - $Z_3 - (4-3)*$d0)*100/$d0")

    printf "%10.2f %15.10f %15.10f %15.10f %15.10f" $ii $Z_1 $delta_12 $delta_23 $delta_34 >> $plot_Relax

    printf "\n" >> $plot_Relax

   # done
done

