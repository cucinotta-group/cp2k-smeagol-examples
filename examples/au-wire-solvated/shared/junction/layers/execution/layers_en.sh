#!/bin/bash
 
layers="3 4 5 6 7 8 9 10 11 12 13 14 15 16" 
 
input_file=Au_slab.inp  
output_file=Au_slab.out  
template_file=Au.inp
job_file=job.pbs

RTYPE=ENERGY

basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=12
Ky=12
Kz=1
cutoff=500
rel_cutoff=40

for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN

    cd $work_dir

    if [ -d $EN_dir ] ; then
        rm -r $EN_dir
    fi

  #  rm Au_slab-v_hartree*
  #  rm Au_slab-efield*
    rm coord.inc
    rm dummy.kp
    rm dummy.inc
    sed -n "/&COORD/,/&END/p" Au_slab-1.restart > coord.inc

    mkdir $EN_dir

    mv Au_slab-RESTART.kp $EN_dir
    mv coord.inc $EN_dir
    rm Au_slab-RESTART*

    cd $EN_dir
    
    # carry on
    cp ../job.pbs .
    cp ../structure_${ii}.xyz .
    cp ../Au_slab-1.restart .


    # tactical input
            # tactical input
    cp ../../forces.inc .
    cp ../../subsys.inc .
    cp ../../scf.inc .
    cp ../../restart.inc .
    cp ../../Au.inp .
    cp ../../motion2.inc .

    structure_file=structure_${ii}.xyz
    M_file=motion2.inc
    WF_file=Au_slab-RESTART.kp
    RF_file=Au_slab-1.restart

    A1=$(grep -e 'Lattice' $structure_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $structure_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $structure_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})

    sed -e "s/LT_cutoff/${cutoff}/g" \
	    -e "s/LT_relcutoff/${rel_cutoff}/g" \
	    -e "s/LT_basis_set/${basis_set}/g" \
	    -e "s/K_x/${Kx}/g" \
	    -e "s/K_y/${Ky}/g" \
	    -e "s/K_z/${Kz}/g" \
	    -e "s/LT_A/${A1}/g" \
	    -e "s/LT_B/${B1}/g" \
	    -e "s/LT_C/${C1}/g" \
	    -e "s/LT_RTYPE/${RTYPE}/g" \
	    -e "s/LT_coord/$structure_file/g" \
	    -e "s/LT_RSCF/TRUE/g" \
	    -e "s/LT_R/FALSE/g" \
	    -e "s/LT_WF/$WF_file/g" \
	    -e "s/LT_RF/$RF_file/g" \
	    $template_file > $input_file

    sed -i "s/'LT_motion'/'$M_file'/g" $input_file

    cd ../..
done

wait 

for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN
    cd $work_dir/$EN_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    qsub $job_file
    cd ../..
done
wait

