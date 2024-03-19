#!/usr/bin/python
from ase.build import fcc111
from ase.io import write,read
from ase.visualize import view


slab = fcc111('Au', size=(2,2,LT_z), vacuum=LT_vacuum, a=4.1983, orthogonal=True)

#a=4.1983
#orthogonal=True

#write output
write('LT_name', slab)
