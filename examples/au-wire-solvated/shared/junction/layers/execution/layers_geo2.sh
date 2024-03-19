#!/bin/bash
 
layers="3 4 5 6 7 8 9 10 11 12 13 14 15 16" 
layers_1="3 5 7 9 11 13 15"
layers_2="4 6 8 10 12 14 16"
 
input_file=Au_slab.inp  
output_file=Au_slab.out  
template_file=Au.inp
job_file=job.pbs
script_file=Au_surface.py
python_file=slab.py

RTYPE=GEO_OPT

basis_set=TZVP-MOLOPT-SR-GTH-q11    
Kx=12
Ky=12
Kz=1
cutoff=500
rel_cutoff=40
#vacuum=10.0

#for scavenging previous files but recall 
#for ii in $layers ; do
#    work_dir=layers_${ii}
#    EN_dir=EN
   # mv $work_dir/$EN_dir/Au_slab-RESTART.kp .
#    cp Au_slab-1.restart .
#    cd ..
#done

for ii in $layers_1 ; do
    work_dir=layers_${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir
    cd $work_dir

        # tactical input
    cp ../../forces.inc .
    cp ../../subsys.inc .
    cp ../../scf.inc .
    cp ../../restart.inc .
    cp ../../Au.inp .
    cp ../../job.pbs .
    cp ../../motion.inc .

	#scavenged
   # mv ../Au_slab-RESTART.kp .
   # mv Au_slab-RESTART.kp WF.kp    
 
        # python and structure
    cp ../../Au_surface.py .

	# defining files
	output2_file=structure_${ii}.xyz
	M_file=motion.inc
	WF_file=dummy.kp
        RF_file=dummy.inc

	Vacuum=$(bc -l <<< "0.5*(56.35834452708209 - 2.423889635*(${ii} - 1))")

    sed -e "s/LT_vacuum/$Vacuum/g" \
	    -e "s/LT_z/${ii}/g" \
	    -e "s/LT_name/structure_${ii}.xyz/g" \
	    $script_file > $python_file

    python3 $python_file

    A1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})

    #num=$(sed "1q;d" $output2_file)
    odd_up=$(bc -l <<< "2*(${ii} + 1)")
    odd_low=$(bc -l <<< "$odd_up - 3") 

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

    sed -i "s/'LT_motion'/'$M_file'/g" $input_file
    sed -i "s/LT_up/${odd_up}/g" $M_file
    sed -i "s/LT_low/${odd_low}/g" $M_file
    
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
    cp ../../forces.inc .
    cp ../../subsys.inc .
    cp ../../scf.inc .
    cp ../../restart.inc .
    cp ../../Au.inp .
    cp ../../job.pbs .
    cp ../../motion.inc .

        # scavenged
   # mv ../Au_slab-RESTART.kp .
   # mv Au_slab-RESTART.kp WF.kp  

    	# python and structure
    cp ../../Au_surface.py .

            # defining files
        output2_file=structure_${ii}.xyz
        M_file=motion.inc
	WF_file=dummy.kp
	RF_file=dummy.inc

	Vacuum=$(bc -l <<< "0.5*(56.35834452708209 - 2.423889635*(${ii} - 1))")

    sed -e "s/LT_vacuum/$Vacuum/g" \
            -e "s/LT_z/${ii}/g" \
            -e "s/LT_name/structure_${ii}.xyz/g" \
            $script_file > $python_file

    python3 $python_file

    A1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $1 " " $2 " " $3'})
    B1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $4 " " $5 " " $6'})
    C1=$(grep -e 'Lattice' $output2_file | tr -d '[="=]' | tr -d '[===]' | tr -d '[:alpha:]' | awk {'print $7 " " $8 " " $9'})

   # num=$(sed "1q;d" $output2_file)
   # con=$(bc -l <<< "$num - 8")
    even_up=$(bc -l <<< "(2*${ii} + 4)")
    even_low=$(bc -l <<< "$even_up - 7")
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
	    -e "s/LT_RSCF/FALSE/g" \
	    -e "s/LT_R/FALSE/g" \
	    -e "s/LT_WF/${WF_file}/g" \
	    $template_file > $input_file

    sed -i "s/'LT_motion'/'$M_file'/g" $input_file
    sed -i "s/LT_up/${even_up}/g" $M_file
    sed -i "s/LT_low/${even_low}/g" $M_file

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
    echo > dummy.kp
    qsub $job_file
    cd ..
done
wait

