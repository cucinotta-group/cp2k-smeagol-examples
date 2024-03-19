#!/usr/bin/python

from ase.build import fcc111
from ase.io import write,read
from ase.visualize import view


slab = fcc111('Au', size=(2,2,16), vacuum=10, a=4.1983, orthogonal=True)

#view(slab)

#write output
write('Au.xyz', slab)
