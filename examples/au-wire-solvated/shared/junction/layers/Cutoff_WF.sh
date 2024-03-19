#!/bin/bash
 
cutoffs="50 100 150 200 250 300 350 400 450 500 550"

input_file=input 
cube_file=cube
set_latest () {
  eval "latest=\${$#}"
}
set_latest Au_slab-v_hartree-1_*.cube
HF_file=$latest 
tmp_file=tmp.dat
script_file=aver.out

output_file=Au_slab.out
aver_file=avermacro_Z.dat
plot_file=cutoff_WF.dat 

for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    POT_dir=POT

    cd $work_dir
 
    if [ -d $POT_dir ] ; then
        rm -r $POT_dir
    fi
    
    mkdir $POT_dir 
    cd $POT_dir

    cp ../../$script_file .
    
    xgrid=$(sed -n -e '4p' ../$HF_file| awk '{print $1}') 
    ygrid=$(sed -n -e '5p' ../$HF_file| awk '{print $1}') 
    zgrid=$(sed -n -e '6p' ../$HF_file| awk '{print $1}') 

    xspacint=$(sed -n -e '4p' ../$HF_file| awk '{print $2}') 
    yspacint=$(sed -n -e '5p' ../$HF_file| awk '{print $3}') 
    zspacint=$(sed -n -e '6p' ../$HF_file| awk '{print $4}') 

    printf "%s %5.10f" $xgrid $xspacint > $input_file 
    printf "\n" >> $input_file
    printf "%s %5.10f" $ygrid $yspacint >> $input_file 
    printf "\n" >> $input_file
    printf "%s %5.10f" $zgrid $zspacint >> $input_file 
    printf "\n" >> $input_file
    echo "1 2 2.42435152" >> $input_file

    sed '1,6d' ../$HF_file > $tmp_file
    sed '/ 79 /d' $tmp_file > $cube_file 

    rm $tmp_file
    ./$script_file < $input_file
 
    cd ../..

    echo ${ii}

    wait 

done
wait 

echo "# Cutoff vs work function" > $plot_file
echo "# Date: $(date)" >> $plot_file
echo "# PWD: $PWD" >> $plot_file
echo -n "# Cutoff (Ry) | Fermi energy (eV) | Potential energy (eV) | Work fuction (eV) " >> $plot_file

printf "\n" >> $plot_file

for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    work_dir_POT=cutoff_${ii}Ry/POT

    en_H=$(grep -e '^[ \t]*Fermi energy' $work_dir/$output_file | tail -n1 | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
   
    pot_H=$(sed -n -e '1p' $work_dir_POT/$aver_file| awk '{print $3}') 
    pot_eV=$( bc -l <<< "( $pot_H * 27.2114 )")

    WF_eV=$( bc -l <<< "( $pot_eV - $en_eV )")
    printf "%5s %5.10f %5.10f %5.10f" $ii $en_eV $pot_eV $WF_eV >> $plot_file
    printf "\n" >> $plot_file
done
