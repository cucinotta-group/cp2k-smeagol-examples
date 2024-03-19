#!/bin/bash
 
lateral="12" 
 
input_file=Au_junction.inp  
output_file=Au_junction.out  
template_file=Au.inp
job_file=job.pbs

RTYPE=ENERGY

basis_set=TZVP-MOLOPT-SR-GTH-q11
Kz=1
cutoff=500
rel_cutoff=40

for ii in $lateral ; do
    work_dir=lateral_${ii}
    EN_dir=wire

    cd $work_dir

    if [ -d $EN_dir ] ; then
        rm -r $EN_dir
    fi

  #  rm Au_slab-v_hartree*
  #  rm Au_slab-efield*
    rm coord.inc
    rm dummy.kp
    rm dummy.inc
   # sed -n "/&COORD/,/&END/p" Au_slab-1.restart > coord.inc

    mkdir $EN_dir

    #rm Au_slab-RESTART*

    cd $EN_dir
    
    # carry on
    cp ../junction_${ii}.xyz .
    cp ../job.pbs .


        # tactical input
   cp ../forces.inc .
   cp ../subsys.inc .
   cp ../scf.inc .
   cp ../restart.inc .
   cp ../Au.inp .
   cp ../motion2.inc .

    structure_file=junction_${ii}.xyz
    M_file=motion2.inc
    WF_file=dummy.kp
    RF_file=dummy.inc

    xi=$( bc -l <<< "( 3*(${ii}^2) + 12 )")
    grep 'Au' $structure_file | head -${xi} | tail -12 | awk {'print $1 " " $2 " " $3 " " $4'} > coord.inc

    A1=$(grep -e 'Lattice' $structure_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $structure_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $structure_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})
    
    Kx=$(bc -l <<< "24/${ii}")
    Ky=$(echo ${Kx} | awk '{print int($1+0.5)}')


    sed -e "s/LT_cutoff/${cutoff}/g" \
	    -e "s/LT_relcutoff/${rel_cutoff}/g" \
	    -e "s/LT_basis_set/${basis_set}/g" \
	    -e "s/K_x/${Ky}/g" \
	    -e "s/K_y/${Ky}/g" \
	    -e "s/K_z/${Kz}/g" \
	    -e "s/LT_A/${A1}/g" \
	    -e "s/LT_B/${B1}/g" \
	    -e "s/LT_C/${C1}/g" \
	    -e "s/LT_RTYPE/${RTYPE}/g" \
	    -e "s/LT_RSCF/FALSE/g" \
	    -e "s/LT_R/FALSE/g" \
	    -e "s/LT_WF/$WF_file/g" \
	    -e "s/LT_RF/$RF_file/g" \
        $template_file > $input_file

    sed -i "s/LT_coord/$structure_file/g" $input_file
    sed -i "s/'LT_motion'/'$M_file'/g" $input_file

    cd ../..
done

wait 

for ii in $lateral ; do
    work_dir=lateral_${ii}
    EN_dir=wire
    cd $work_dir/$EN_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    echo > dummy.kp
    echo > dummy.inc
    #sed -i "s/LT_job/wire_${ii}/g" $job_file
    qsub $job_file
    cd ../..
done
wait

