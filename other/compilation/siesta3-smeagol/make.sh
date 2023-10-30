#!/bin/bash

cd Obj
make clean

# Compile MKLDFT
cd MKLDFT
cp  ${MKLROOT}/include/mkl_dfti.f90 .
make clean
make

# Copy automatic_cell.o from siesta young install
cp /shared/ucl/apps/siesta/4.0.1/intel-2017/siesta-4.0.1/Obj/automatic_cell.o .

cd ..
make

