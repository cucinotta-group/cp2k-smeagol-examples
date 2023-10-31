#!/bin/bash
fdffile=$1
#xsffile=`echo $fdffile| sed 's/.fdf$/_1x1x1.xsf/'`
expand_cell3.pl $fdffile 0 0 1 1 1 0 0 0
