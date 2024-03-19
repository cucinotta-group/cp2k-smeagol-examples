#!/bin/bash
 
lateral="4 6 8 10 12 14" 
 
input_file=Au_junction.inp  
output_file=Au_junction.out  
template_file=Au.inp
job_file=job.pbs
script_file=junction_even.py

RTYPE=ENERGY

basis_set=TZVP-MOLOPT-SR-GTH-q11    
cutoff=500
rel_cutoff=40
layers=5
wire=4
w_spac=1

#for scavenging previous files but recall 
#for ii in $layers ; do
#    work_dir=layers_${ii}
#    EN_dir=EN
#    mv $work_dir/$EN_dir/Au_slab-RESTART.kp WF_${ii}.kp
#    mv $work_dir/Au_slab-1.restart Au_slab_${ii}.restart
#    mv $work_dir/$EN_dir/coord.inc coord_${ii}.inc    
#done

for ii in $lateral ; do
    work_dir=lateral_${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir
    cd $work_dir

        # tactical input
   cp ../forces.inc .
   cp ../subsys.inc .
   cp ../scf.inc .
   cp ../restart.inc .
   cp ../Au.inp .
   cp ../job.pbs .
   cp ../motion2.inc .

	#scavenged
#    mv ../WF_${ii}.kp .
#    mv ../coord_${ii}.inc .
#    mv WF_${ii}.kp Au_slab-RESTART.kp
#    mv ../Au_slab_${ii}.restart .    
 
        # python and structure
    cp ../junction_even.py .

	# defining files
	python_file=junction_${ii}.py
	output2_file=junction_${ii}.xyz
	M_file=motion2.inc
	WF_file=dummy.kp
        RF_file=dummy.inc

    sed -e "s/LT_N/${ii}/g" \
	    -e "s/LT_layers/${layers}/g" \
	    -e "s/LT_wire/${wire}/g" \
	    -e "s/LT_spac/${w_spac}/g" \
	    -e "s/'LT_name'/'$output2_file'/g" \
	    $script_file > $python_file

    python3 $python_file

    A1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})

    lower=1
    upper=$(bc -l <<< "${ii}^2 - 1")
    Kx=$(bc -l <<< "24/${ii}")
    Ky=$(echo ${Kx} | awk '{print int($1+0.5)}')
    Kz=1

    sed -e "s/LT_cutoff/$cutoff/g" \
	    -e "s/LT_relcutoff/${rel_cutoff}/g" \
	    -e "s/LT_basis_set/${basis_set}/g" \
	    -e "s/K_x/${Ky}/g" \
	    -e "s/K_y/${Ky}/g" \
	    -e "s/K_z/${Kz}/g" \
	    -e "s/LT_coord/${output2_file}/g" \
	    -e "s/LT_A/${A1}/g" \
	    -e "s/LT_B/${B1}/g" \
	    -e "s/LT_C/${C1}/g" \
	    -e "s/LT_RTYPE/${RTYPE}/g" \
	    -e "s/LT_RF/${RF_file}/g" \
	    -e "s/LT_RSCF/FALSE/g" \
	    -e "s/LT_R/FALSE/g" \
	    -e "s/LT_WF/${WF_file}/g" \
	    $template_file > $input_file

    sed -i "s/'LT_motion'/'$M_file'/g" $input_file
   # sed -i "s/LT_up/${upper}/g" $M_file
   # sed -i "s/LT_low/${lower}/g" $M_file
    
    cd ..

done

wait 

for ii in $lateral ; do
    work_dir=lateral_${ii}
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    echo > coord.inc
    echo > dummy.inc
    echo > dummy.kp
    sed -i "s/LT_job/junction_${ii}/g" $job_file
    qsub $job_file
    cd ..
done
wait

