#!/bin/bash
 
cutoffs="50 100 150 200 250 300 350 400 450 500 550 600 650 700"
 
input_file=input.inp
output_file=log.out 
template_file=template.inp
job_file=submit.slurm
geometry=unit_cell.xyz

Kx=1
Ky=1
Kz=1
rel_cutoff=60
 
for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir

    sed -e "s/LT_rel_cutoff/$rel_cutoff/g" \
        -e "s/LT_cutoff/${ii}/g" \
        -e "s/Kx/${Kx}/g" \
        -e "s/Ky/${Ky}/g" \
        -e "s/Kz/${Kz}/g" \
        $template_file > $input_file

    cd $work_dir 
    mv ../$input_file .
	cp ../$geometry .
    cp ../$job_file .
    cd ..

done

wait 

for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    sbatch $job_file
    cd ..
done
wait
