#!/bin/bash

allfiles="*VH *RHO"
echo $allfiles
for filei in $allfiles ; do

    suffix=`echo $filei|sed 's/.*\.//;s/VH/vh/;s/RHO/rho/'`
    prefix="`echo $filei|sed 's/.[^.]*$//'`"
	echo "'$prefix'      		System label, used to name input files
   '$suffix'              		Function(s) to plot ('rho'|'ldos'|'spin'|'vt'|'vh')
   0.0  0.0  0.0      		Euler rotation angles alpha, beta, gamma
   4.e-1              		Value of electron density (or LDOS) for isosurface
  -0.2  +0.2  +1.0    		Saturation range for color function
   'unformatted'      		Data format ('formatted'|'unformatted')
   '/XWIN'            		Output option ('/XWIN'|'/PS'|'/CPS'|+more)
   6.6594 	           	Planar average width (Bohr) 5.33848
   0.000			Position Shift 42.70783d0	
   0.000			Energy Shift
   'N'				Global Shift of the Position
   0.0d0			Global Shift of the Position 42.70783d0	
   1" > Potential.dat
   Pot.exe

done