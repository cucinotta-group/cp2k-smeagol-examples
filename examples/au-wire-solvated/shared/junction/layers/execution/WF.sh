#!/bin/bash
 
layers="3 4 5 6 7 8 9 10 11 12 13 14 15 16"

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
plot_file=layers_WF.dat 

for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN
    POT_dir=POT

    cd $work_dir/$EN_dir
 
    if [ -d $POT_dir ] ; then
        rm -r $POT_dir
    fi
    
    mkdir $POT_dir 
    cd $POT_dir

    cp ../../../$script_file .
    
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
    echo "1 2 2.423889635" >> $input_file

    sed '1,6d' ../$HF_file > $tmp_file
    sed '/ 79 /d' $tmp_file > $cube_file 

    rm $tmp_file
    ./$script_file < $input_file
 
    cd ../../..

    echo ${ii}

    wait 

done
wait 

echo "# N_layers vs work function" > $plot_file
echo "# Date: $(date)" >> $plot_file
echo "# PWD: $PWD" >> $plot_file
echo -n "# layers | Fermi energy (eV) | Potential energy (eV) | Work fuction (eV) " >> $plot_file

printf "\n" >> $plot_file

for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN
    work_dir_POT=layers_${ii}/EN/POT

    en_H=$(grep -e '^[ \t]*Fermi energy' $work_dir/$EN_dir/$output_file | tail -n1 | awk '{print $3}')
    en_eV=$( bc -l <<< "( $en_H * 27.2114 )")
   
    pot_H=$(sed -n -e '1p' $work_dir_POT/$aver_file| awk '{print $3}') 
    pot_eV=$( bc -l <<< "( $pot_H * 27.2114 )")

    WF_eV=$( bc -l <<< "( $pot_eV - $en_eV )")
    printf "%5s %5.10f %5.10f %5.10f" $ii $en_eV $pot_eV $WF_eV >> $plot_file
    printf "\n" >> $plot_file
done
