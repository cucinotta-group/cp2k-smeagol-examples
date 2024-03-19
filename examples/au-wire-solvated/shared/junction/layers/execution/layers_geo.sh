#!/bin/bash
 
layers="3 4 5 6 7 8 9 10 11 12 13 14 15" 
layers_1="3 4"
layers_2="5 6 7 8 9 10 11 12 13 14 15"
 
input_file=Au_slab.inp  
output_file=Au_slab.out  
template_file=Au.inp
job_file=job.pbs
script_file=Au_surface.py
python_file=slab.py

RTYPE=GEO_OPT

basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=11
Ky=11
Kz=1
cutoff=350
rel_cutoff=40
#vacuum=10.0

for scavenging previous files but recall 
for ii in $layers ; do
    work_dir=layers_${ii}
    EN_dir=EN
    mv $work_dir/$EN_dir/Au_slab-RESTART.kp .
#    cp Au_slab-1.restart .
#    cd ..
done

for ii in $layers_1 ; do
    work_dir=layers_${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir
    cd $work_dir

        # tactical input
    cp /rds/general/user/jj1921/home/Au_slab/forces.inc .
    cp /rds/general/user/jj1921/home/Au_slab/subsys.inc .
    cp /rds/general/user/jj1921/home/Au_slab/scf.inc .
    cp /rds/general/user/jj1921/home/Au_slab/restart.inc .
    cp /rds/general/user/jj1921/home/Au_slab/Au.inp .
    cp /rds/general/user/jj1921/home/Au_slab/job.pbs .
    cp /rds/general/user/jj1921/home/Au_slab/motion2.inc .

	#scavenged
    mv ../Au_slab-RESTART.kp .
    mv Au_slab-RESTART.kp WF.kp    
 
        # python and structure
    cp /rds/general/user/jj1921/home/Au_slab/Au_surface.py .

	# defining files
	output2_file=structure_${ii}.xyz
	M2_file=motion2.inc
	WF_file=WF.kp
        RF_file=dummy.inc

	Vacuum=$(bc -l <<< "0.5*(53.93445489194328 - 2.423889635*(${ii} - 1))")

    sed -e "s/LT_vacuum/$Vacuum/g" \
	    -e "s/LT_z/${ii}/g" \
	    -e "s/LT_name/structure_${ii}.xyz/g" \
	    $script_file > $python_file

    python3 $python_file

    A1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})

    sed -e "s/LT_cutoff/$cutoff/g" \
	    -e "s/LT_relcutoff/${rel_cutoff}/g" \
	    -e "s/LT_basis_set/${basis_set}/g" \
	    -e "s/K_x/${Kx}/g" \
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

    sed -i "s/'LT_motion'/'$M2_file'/g" $input_file
    cd ..

done

for ii in $layers_2 ; do
    work_dir=layers_${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir
    cd $work_dir

        # tactical input
    cp /rds/general/user/jj1921/home/Au_slab/forces.inc .
    cp /rds/general/user/jj1921/home/Au_slab/subsys.inc .
    cp /rds/general/user/jj1921/home/Au_slab/scf.inc .
    cp /rds/general/user/jj1921/home/Au_slab/restart.inc .
    cp /rds/general/user/jj1921/home/Au_slab/Au.inp .
    cp /rds/general/user/jj1921/home/Au_slab/job.pbs .
    cp /rds/general/user/jj1921/home/Au_slab/motion.inc .

        # scavenged
    mv ../Au_slab-RESTART.kp .
    mv Au_slab-RESTART.kp WF.kp  

    	# python and structure
    cp /rds/general/user/jj1921/home/Au_slab/Au_surface.py .

            # defining files
        output2_file=structure_${ii}.xyz
        M1_file=motion.inc
	WF_file=WF.kp
	RF_file=dummy.inc

	Vacuum=$(bc -l <<< "0.5*(53.93445489194328 - 2.423889635*(${ii} - 1))")

    sed -e "s/LT_vacuum/$Vacuum/g" \
            -e "s/LT_z/${ii}/g" \
            -e "s/LT_name/structure_${ii}.xyz/g" \
            $script_file > $python_file

    python3 $python_file

    A1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})

    num=$(sed "1q;d" $output2_file)
   # con=$(bc -l <<< "$num - 8")
    odd=$(bc -l <<< "2*($num + 1)") #odd
    even=$(bc -l <<< "4*(0.5*$num + 1)")
    con2=$(seq -s ' ' 10 $con)

    sed -e "s/LT_cutoff/$cutoff/g" \
	    -e "s/LT_relcutoff/${rel_cutoff}/g" \
	    -e "s/LT_basis_set/${basis_set}/g" \
	    -e "s/K_x/${Kx}/g" \
	    -e "s/K_y/${Ky}/g" \
	    -e "s/K_z/${Kz}/g" \
	    -e "s/LT_coord/${output2_file}/g" \
	    -e "s/LT_A/${A1}/g" \
	    -e "s/LT_B/${B1}/g" \
	    -e "s/LT_C/${C1}/g" \
	    -e "s/LT_RTYPE/${RTYPE}/g" \
	    -e "s/LT_RF/${RF_file}/g" \
	    -e "s/LT_RSCF/TRUE/g" \
	    -e "s/LT_R/FALSE/g" \
	    -e "s/LT_WF/${WF_file}/g" \
	    $template_file > $input_file

    sed -i "s/'LT_motion'/'$M1_file'/g" $input_file
    sed -i "s/LT_up/${con}/g" $M1_file
    sed -i "s/LT_low/9/g" $M1_file

    cd ..

done

wait 

for ii in $layers ; do
    work_dir=layers_${ii}
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    echo > coord.inc
    echo > dummy.inc
   # echo > dummy.kp
    qsub $job_file
    cd ..
done
wait

