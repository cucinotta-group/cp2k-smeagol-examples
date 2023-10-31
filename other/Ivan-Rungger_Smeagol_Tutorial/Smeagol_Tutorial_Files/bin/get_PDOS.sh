#!/bin/bash

#the input file has to have the following format:
#
#>#Mn4s         -> ending of output file name for this run
#>1                      -> atom index as in siesta
#>4                      -> n
#>0                      -> l
#>9                      -> m ( 9 is for all m)
#
#The input file can have any number of the above blocks
#No empty lines are allowed.
#
#

if [ $# -ne 3 ] ; then
	echo "usage:
    get_PDOS file.PDOS input_file fermi_zero
where:
file.PDOS is the output file of siesta with the PDOS
input_file is the input file for get_PDOS
fermi_zero : if set to 0 the fermi energy is set to zero, for all other values it is left unchanged
"
	exit
fi

pdos_file=$1
input_file=$2
fermi_zero=$3

fermi_energy=0.0
echo "fermi_energy=$fermi_energy"

if [ $fermi_zero -eq 0 ] ; then
	perl -x $0 $fermi_energy < $pdos_file > $pdos_file.scaled
	fermi_energy=0
else
	cp  $pdos_file  $pdos_file.scaled
fi

nspin=`grep nspin $pdos_file|sed 's/<nspin>//;s/<.nspin>//'`
echo nspin=$nspin

grace_pdos_par="grace_pdos.par"
echo "legend 1.1, 1
map color 1 to (0, 0, 0), \"black\"
map color 2 to (255, 0, 0), \"red\"
map color 3 to (0, 255, 0), \"green\"
map color 4 to (0, 0, 255), \"blue\"
map color 5 to (255, 255, 0), \"yellow\"
map color 6 to (188, 143, 143), \"brown\"
map color 7 to (0, 139, 0), \"green4\"
map color 8 to (0, 255, 255), \"cyan\"
map color 9  to (255, 0, 255), \"magenta\"
map color 10 to (255, 165, 0), \"orange\"
map color 11 to (114, 33, 188), \"indigo\"
map color 12 to (103, 7, 72), \"maroon\"
map color 13 to (64, 224, 208), \"turquoise\"
map color 14 to (148, 0, 211), \"violet\"
map color 15 to (122, 0, 122), \"magenta\"
map color 16 to (122, 80, 0), \"orange\"
map color 17 to (60, 20, 90), \"indigo\"
map color 18 to (50, 3, 36), \"maroon\"
map color 19 to (220, 220, 220), \"grey\"
map color 20 to (10, 110, 100), \"turquoise\"" > $grace_pdos_par

OLD_IFS="$IFS"
IFS='#'
#cat $input_file
fm_inputs=( `cat $input_file| sed -e '1s/^#\(.*\)/\1/'` )
IFS="$OLD_IFS"

num_runs=${#fm_inputs[@]}
echo "num_runs=$num_runs"
i1=0
set_num_up=0
set_num_down=1
color_num=1

xmgrace_args=""
while [ $i1 -lt $num_runs ] ; do
	echo "i1=$i1"
	echo -n "current:${fm_inputs[$i1]}"
	fmPDOS_input="$pdos_file.scaled
$pdos_file.${fm_inputs[$i1]}"
	echo -n "fmPDOS_input=$fmPDOS_input"
	echo "$fmPDOS_input" | fmPDOS

	in_i1=( ${fm_inputs[$i1]} )
	echo "in_i1[0]=${in_i1[0]}"
	outfile_name="${pdos_file}.${in_i1[0]}"
	echo "outfile_name=$outfile_name"
	
	xmgrace_args="$xmgrace_args -nxy $outfile_name"
	#echo "xmgrace_args=${xmgrace_args}"
	ending=${outfile_name##*PDOS.}
	echo $ending
	echo "S${set_num_up} legend \"${ending}\"
S${set_num_up} line color $color_num
S${set_num_up} line linewidth 2.0
S${set_num_down} line color $color_num
S${set_num_down} line linewidth 2.0" >> $grace_pdos_par

	i1=$(( $i1 + 1 ))
	set_num_up=$(( $set_num_up + $nspin ))
	set_num_down=$(( $set_num_down + $nspin ))
	color_num=$(( $color_num + 1 ))
	if [ $color_num -gt 20 ] ; then color_num=1 ; fi
done

echo "S${set_num_up} line color 1" >> $grace_pdos_par

xmgrace_args="$xmgrace_args -batch $grace_pdos_par -saveall ${pdos_file}.agr -pipe"

##xmgrace $xmgrace_args & <<EOF_FERMI
##$fermi_energy -0.005
##$fermi_energy 0.005
##EOF_FERMI
##

exit

# start of perl part of the file
#!/usr/bin/perl

$e_fermi=$ARGV[0];

while ( $line = <STDIN> )
{
	print $line;
	if ($line =~ m/<energy_values units=.*$/)
	{
		while ( ($line = <STDIN> ) && ! ( $line =~ m/<\/energy_values.*$/))
		{
			$line =~ m/^[ 	]*([^ ]*)[ 	]*$/;
			$ene=$1;
			print "             ".($ene-$e_fermi)."\n";
		}
		print $line;
	}	
}

