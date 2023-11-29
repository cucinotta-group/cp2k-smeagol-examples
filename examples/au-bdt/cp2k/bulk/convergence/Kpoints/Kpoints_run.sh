#!/bin/bash
 
Kpoints="2 4 6 8 10 12 14 16 18 20 22 24 26 28 30" 

input_file=input.inp
output_file=log.out 
template_file=template.inp
job_file=submit.slurm
geometry=unit_cell.xyz

cutoff=500
rel_cutoff=60

for ii in $Kpoints ; do
    work_dir=Kpoints_${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir

    sed -e "s/LT_rel_cutoff/${rel_cutoff}/g" \
        -e "s/LT_cutoff/${cutoff}/g" \
        -e "s/Kx/${ii}/g" \
        -e "s/Ky/${ii}/g" \
        -e "s/Kz/${ii}/g" \
        $template_file > $input_file

    cd $work_dir 
    cp ../$input_file .
    cp ../$job_file .
    cp ../$geometry .
    cd ..

done

wait 

for ii in $Kpoints ; do
    work_dir=Kpoints_${ii}
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    sbatch $job_file 
    cd ..
done

wait
