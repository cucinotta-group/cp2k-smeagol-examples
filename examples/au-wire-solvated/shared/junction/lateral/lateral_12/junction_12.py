#!/usr/bin/python

from ase.build import fcc111
from ase.build import add_adsorbate
from ase import Atoms
from ase.io import write,read
from ase.visualize import view
import numpy as np

# alpha, d & N are the lattice parameter (bulk), interplanar spacing and later dimensions (NxNxlayers)
alpha=4.1983
d = alpha/(3**0.5)
# only use even values
N = 12

# junction layers considering PBC
layers= 5
if (layers % 2) == 0:
    Nz = layers
else:
    Nz = layers + 1

# number of atoms in wire
wire = 4
# wire spacing: multiples of interplanar spacing
w_spac = 1
       
# Defining the lower base electrode orthogonally
elec = fcc111('Au', size=(N,N,Nz), vacuum=None, a=4.1983, orthogonal=True)

# extracting cell parameters useful for later 
unit = elec.get_cell()

# cuts the upper layers of the electrode; x*d means x + 1 layers are kept
Z = (Nz/2)*d
del elec[elec.positions[:, 2] > Z]

# provides index for creating the tip base, or pyramid with L, R, U corresponding to left, right and upper vertices
L = int(((Nz + 1)*(N**2) - 2)/2 - N/2)
R = int(L + 1)
if ((N/2) % 2) == 0:
    U = int(R + N - 1) 
else:
    U = int(R + N)

del elec[[atom.index for atom in elec if (atom.index > U)]]
del elec[[atom.index for atom in elec if (R < atom.index < U)]]
del elec[[atom.index for atom in elec if ((int((Nz/2)*N**2 - 1)) < atom.index < L)]]

# to verify pyramid built correctly
view(elec)

# coordinates of upper atom in pyramid labeled 'mid' 
mid = elec.get_positions()[int((Nz/2)*N**2 + 2), :]

# translation vectors
Lx= (1/4)*(2**0.5)*alpha
Ly=(1/12)*(6**0.5)*alpha
Lz=d
trans=np.array([Lx, Ly, Lz])
b_1= mid + np.array([0, -2, 1])*trans

# wire
w = np.zeros((wire, 3))
w[0, :] = b_1 + np.array([0, 0, w_spac])*trans
for i in range( 1, wire):
    print(i)
    w[i, :] = w[(i-1), :] + np.array([0, 0, w_spac])*trans
print(w)

#second base
b_2 = w[(wire - 1), :] + np.array([0, 0, w_spac])*trans

#upper pyramid
p_d = b_2 + np.array([0, -2, 1])*trans
p_l= b_2 + np.array([-1, 1, 1])*trans
p_r= b_2 + np.array([1, 1, 1])*trans

filament = Atoms('Au', positions=[b_1])\
            + Atoms('Au', positions=[w[0, :]])\
            + Atoms('Au', positions=[w[1, :]])\
            + Atoms('Au', positions=[w[2, :]])\
            + Atoms('Au', positions=[w[3, :]])\
            + Atoms('Au', positions=[b_2])\
            + Atoms('Au', positions=[p_d])\
            + Atoms('Au', positions=[p_l])\
            + Atoms('Au', positions=[p_r])

N_z = int(Nz/2)
elec2 = fcc111('Au', size=(N,N,N_z), vacuum=None, a=4.1983, orthogonal=True)

if (layers % 2) == 0:
    elec2.translate([0, 0, (d+p_d[2])])
else:
    del elec2[elec2.positions[:, 2] < d/2 ]
    elec2.translate([0, 0, (p_d[2])])

junction = elec + filament + elec2

# set unit cell of junction, ref denotes reference to get Z-position of last atom 
ref = elec2.get_positions()[(len(elec2.get_positions()) - 1), :]
junction.set_cell([[unit[0, 0], unit[0, 1], unit[0, 2]], [unit[1, 0], unit[1, 1], unit[1, 2]], [0.0, 0.0, (d+ref[2])]])
junction.set_tags(range(len(junction)))

# to observe junction or create multi_unit cell
#junction = junction.repeat((1,1,2))
#view(junction)

# extract structure file
write('junction_12.xyz', junction)
