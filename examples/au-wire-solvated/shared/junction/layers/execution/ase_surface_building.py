#!/usr/bin/python

from ase.build import fcc110
from ase.io import write,read
from ase.visualize import view


slab = fcc110('Al', size=(4,4,18), vacuum=0)

view(slab)

#write output
write('Al_110_x4y4z18.xyz', slab)
