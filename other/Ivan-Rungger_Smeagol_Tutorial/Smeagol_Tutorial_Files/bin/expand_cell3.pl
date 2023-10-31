#!/usr/bin/perl

if($#ARGV !=8) 
{
print STDERR "usage: expand_cell.pl fdf_file whole_fdf sort nx ny nz dx dy dz
where : fdf_file is the input fdf file
        whole_fdf if 0 then the whole fdf file is output with the new coordinates, else only the new coordinates are output
        if sort is 0 then the output coordinates are unsorted, and have the same order as the input coordinates; if sort is 1, the output coordinates are sorted along z, then along x, and then along y; if sort is 2, the output coordinates are sorted along z, then along y, and then along x;
        nx, ny, nz are the factors by which the cell is expanded in the l1, l2, l3 directions, respectively
        dx, dy, dz are the dislocations of the lattice in x,y,z directions, respectively\n";
#        units determines which units are used for latticeconstant and atomic coordinates in the output fdf file; it is either 0 for Angstrom, or 1 for Bohr\n";
exit;
}

$input_file=$ARGV[0];
$outfdf=$ARGV[1];
$dosort=$ARGV[2];
$n1=$ARGV[3];
$n2=$ARGV[4];
$n3=$ARGV[5];
$d1=$ARGV[6];
$d2=$ARGV[7];
$d3=$ARGV[8];
#$units=$ARGV[9];

$bohrtoang=0.529177249;
$infbase=$input_file;
$infbase=~ s/.fdf$//;
print "infbase=$infbase\n";
$outfbase=$infbase."_".$n1."x".$n2."x".$n3;
print "outfbase=$outfbase\n";
$outfile=$outfbase.".fdf";
$xsf_file=$outfbase.".xsf";
$xyz_file=$outfbase.".xyz";

$nmult[0]=$n1;
$nmult[1]=$n2;
$nmult[2]=$n3;

open(INF,"< $input_file")|| die("can't open $input_file: $!");
open(OUTF,"> $outfile")|| die("can't open $outfile: $!");

$atomnr=1;

while ( $line = <INF> )
  {

    $linep = $line;
    $linep =~ s/_//g;

	if (($linep =~ m/^[ 	]*#/)||($line =~ m/^[ 	]*%%/)){
		if($outfdf == 0){ print OUTF $line; }
        next;
    }
	elsif ($linep =~ m/\%block +ChemicalSpeciesLabel/){
		$i1=1;
		if($outfdf == 0){ print OUTF $line; }
		while ( $line = <INF> ) {
            $linep = $line;
            $linep =~ s/_//g;
            if($linep =~ m/\%endblock +ChemicalSpeciesLabel/ ){last;}
			$line =~ m/^[ 	]*([0-9]+)[ 	]+([0-9]+)[ 	]+([^ 	]+)[ 	]*.*$/i;
			$ind=$1;
			$inda[$i1]=$ind;
			$species[$ind]=$2;
			$namespecies[$ind]=$3;
      chomp($namespecies[$ind]);
#      print "name=$namespecies[$ind]\n";

			#print "cell[$i1]=".$cell[$i1][0]." ".$cell[$i1][1]." ".$cell[$i1][2]."\n";
			if($outfdf == 0){ 
				print OUTF " ".$inda[$i1]." ".$species[$i1]." ".$namespecies[$i1]."\n";
			}
			$i1++;
		}
		if($outfdf == 0){ print OUTF $line; }
	}
	elsif ($linep =~ m/NumberOfAtoms[ 	]+([-0-9.]+)[ 	]*.*/i){
			$natoms=$1;
			$natoms= $natoms * $n1 * $n2 * $n3 ;
		if($outfdf == 0){ 
			print OUTF "NumberOfAtoms    $natoms\n";
		}
	}
	elsif ($linep =~ m/\%block +LatticeVectors/i){
		$i1=0;
		if($outfdf == 0){ print OUTF $line; }
		while ( $line = <INF> ) {
            $linep = $line;
            $linep =~ s/_//g;
            if($linep =~ m/\%endblock +LatticeVectors/i ){last;}
			$line =~ m/^[ 	]*([-0-9.]+)[ 	]+([-0-9.]+)[ 	]+([-0-9.]+)[ 	]*/g;
			$cell[$i1][0]=$1;
			$cell[$i1][1]=$2;
			$cell[$i1][2]=$3;

			#print "cell[$i1]=".$cell[$i1][0]." ".$cell[$i1][1]." ".$cell[$i1][2]."\n";
			if($outfdf == 0){ 
				printf OUTF ("  % 13.10f % 13.10f % 13.10f\n",$nmult[$i1] * $cell[$i1][0],$nmult[$i1] * $cell[$i1][1],$nmult[$i1] * $cell[$i1][2]);
			}
			$i1++;
		}
		if($outfdf == 0){ print OUTF $line; }
	}
  elsif ($linep =~ m/^[ 	]*LatticeConstant/i){
		$linep =~ m/^[ 	]*LatticeConstant[ 	]*([-0-9.]+)[ 	]+([^ 	]*)/ig;
		$lc=$1;
		$lcunits=$2;
        chomp($lcunits);
#        print "lcunits=$lcunits\n";

		if($lcunits =~ m/ang/i){
   #     	print "lcunits=angstrom\n";
  			$lcang=$lc ;}
		elsif($lcunits =~ m/bohr/i){
   #     	print "lcunits=bohr\n";
  			$lcang=$lc * $bohrtoang ;}
		else{
        	print "The units of the \"LatticeConstant\" option have to be either \"Ang\" or \"bohr\". Please change your input file. Exiting..\n";
            print "lcunits=$lcunits\n";
			exit; }


	  if($outfdf == 0){ print OUTF $line; }
  }
  elsif ($linep =~ m/AtomicCoordinatesFormat/i){
		$linep =~ m/^[ 	]*AtomicCoordinatesFormat[ 	]+([^ 	]*)/ig;
		$acunits=$1;
        chomp($acunits);

#        print "acunits=$acunits\n";

		if($acunits =~ m/ang/i){
   #     	print "acunits=angstrom\n";
  			$acang=1.0 ;}
		elsif($acunits =~ m/bohr/i){
   #     	print "acunits=bohr\n";
  			$acang=1.0 * $bohrtoang ;}
		elsif($acunits =~ m/scaledcartesian/i){
   #     	print "lcunits=bohr\n";
  			$acang=$lcang ;}
		else{
        	print "The \"AtomicCoordinatesFormat\" option has to be either \"Ang\", \"bohr\", or \"ScaledCartesian\". Please change your input file. Exiting..\n";
			exit; }

	  if($outfdf == 0){ print OUTF $line; }

	}
	elsif ($linep =~ m/%block[ 	]+AtomicCoordinatesAndAtomicSpecies/i)
	{
		if($outfdf == 0){ print OUTF $line; }
#		while ( ( $line = <INF> ) && $line !~ m/block[ 	]+AtomicCoordinatesAndAtomicSpecies/i ){
		while ( $line = <INF> ) {
            $linep = $line;
            $linep =~ s/_//g;
            if($linep =~ m/block[ 	]+AtomicCoordinatesAndAtomicSpecies/i ){last;}
			if ($line =~ m/^[ 	]*([-.0-9]+)[ 	]+([-.0-9]+)[ 	]+([-.0-9]+)[ 	]+([-.0-9]+)[ 	]*.*$/)
			{
				$v1[$atomnr][0]=$1 - $d1;
				$v1[$atomnr][1]=$2 - $d2;
				$v1[$atomnr][2]=$3 - $d3;
				$atom_number[$atomnr]=$4;
				$atomnr++;
			}	
		}

		$natoms=$atomnr-1;

		$na=0;
		for($atomnr=1;$atomnr <= $natoms;$atomnr++){
			for($i1=1;$i1 <= $n1;$i1++){
				for($i2=1;$i2 <= $n2;$i2++){
					for($i3=1;$i3 <= $n3;$i3++){
						for($i=0;$i < 3;$i++){
							$a1[$na][$i]=$v1[$atomnr][$i]+ ($i1-1) * $cell[0][$i]+ ($i2-1) * $cell[1][$i]+ ($i3-1) * $cell[2][$i] ;
						}
						$a1[$na][3]=$atom_number[$atomnr];
						$na++;
					}
				}
			}
		}

		$natoms=$na;

#		foreach (@a1) {
#		  foreach (@{$_}) {
#		  }
#		} 

		if($dosort == 1){
			@a2= sort { $a->[2] <=> $b->[2] || $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] } @a1;
#		@a2= sort { ${a}[2] <=> ${b}[2] } @a1;
		}
		elsif($dosort == 2){
			@a2= sort { $a->[2] <=> $b->[2] || $a->[1] <=> $b->[1] || $a->[0] <=> $b->[0] } @a1;
		}
		elsif($dosort == 3){
			@a2= sort { $a->[3] <=> $b->[3] || $a->[2] <=> $b->[2] || $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] } @a1;
		}
		elsif($dosort == 3){
			@a2= sort { $a->[3] <=> $b->[3] || $a->[2] <=> $b->[2] || $a->[1] <=> $b->[1] || $a->[0] <=> $b->[0] } @a1;
		}
		else{
			for($na=0;$na < $natoms;$na++){
				$a2[$na][0]=$a1[$na][0];
				$a2[$na][1]=$a1[$na][1];
				$a2[$na][2]=$a1[$na][2];
				$a2[$na][3]=$a1[$na][3];
			}
		}

		for($na=0;$na < $natoms;$na++){
			printf OUTF ("  % 13.10f % 13.10f % 13.10f %d\n",$a2[$na][0], $a2[$na][1], $a2[$na][2], $a2[$na][3]);
		}

		if($outfdf == 0){ print OUTF $line; }
	}	
	else
	{
		if($outfdf == 0){ print OUTF $line; }
	}
}

close(INF);
close(OUTF);

#$lc=1.00;
#if($units==1){
#  $lcang=$lc * $bohrtoang ;
#}

open(OUTF,"> $xsf_file")|| die("can't open $xsf_file: $!");

print OUTF "CRYSTAL\nPRIMVEC\n";
for($i=0;$i < 3;$i++){
	printf OUTF ("  % 13.9f % 13.9f % 13.9f\n",$lcang * $nmult[$i] * $cell[$i][0],$lcang * $nmult[$i] * $cell[$i][1],$lcang * $nmult[$i] * $cell[$i][2]);
}
print OUTF "PRIMCOORD\n";
print OUTF "$natoms   1\n";

for($na=0;$na < $natoms;$na++){
	printf OUTF ("  %4d  % 13.9f % 13.9f % 13.9f \n",$species[$a2[$na][3]],$acang * $a2[$na][0],$acang *  $a2[$na][1],$acang *  $a2[$na][2]);
}
close(OUTF);

open(OUTF,"> $xyz_file")|| die("can't open $xyz_file: $!");
print OUTF "$natoms\n\n";

for($na=0;$na < $natoms;$na++){
	printf OUTF ("  %s  % 13.9f % 13.9f % 13.9f \n",$namespecies[$a2[$na][3]],$acang * $a2[$na][0],$acang *  $a2[$na][1],$acang *  $a2[$na][2])
}


close(OUTF);
