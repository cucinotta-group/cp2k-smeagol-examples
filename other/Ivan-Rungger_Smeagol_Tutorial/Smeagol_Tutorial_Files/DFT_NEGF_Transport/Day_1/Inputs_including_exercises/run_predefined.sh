#!/bin/bash

tdir=`pwd`

smeagol="smeagol-1.2_csg_tutorial"

cd $tdir/leads-1D/
eval mpirun -n 1  $smeagol < input.fdf > out
cp bulk* *HST *DM ../example1
cp bulk* *HST *DM ../example1/exercise_1
cp bulk* *HST *DM ../example1/exercise_2
cp bulk* *HST *DM ../example1/exercise_3

cd $tdir/leads-1D/spinpolarized
eval mpirun -n 1  $smeagol < input.fdf > out
cp bulk* *HST *DM ../../example2
cp bulk* *HST *DM ../../example2/exercise_1
cp bulk* *HST *DM ../../example2/exercise_2/P
cp bulk* *HST *DM ../../example2/exercise_2/AP

cd $tdir/leads-2D/
eval mpirun -n 1  $smeagol < input.fdf > out
cp bulk* *HST *DM ../example3
cp bulk* *HST *DM ../example3/exercise_1
cp bulk* *HST *DM ../example3/exercise_2
cp bulk* *HST *DM ../example4
cp bulk* *HST *DM ../example5
cp bulk* *HST *DM ../example5/exercise_1

cd $tdir/example1
eval mpirun -n 8 $smeagol < input.fdf > out

cd $tdir/example1/exercise_1
eval mpirun -n 4 $smeagol < input.fdf > out

cd $tdir/example1/exercise_2
eval mpirun -n 8 $smeagol < input.fdf > out

cd $tdir/example1/exercise_3
eval mpirun -n 8 $smeagol < input.fdf > out

cd $tdir/example2
eval mpirun -n 8 $smeagol < input.fdf > out

cd $tdir/example2/exercise_1
eval mpirun $smeagol < input.fdf > out

cd $tdir/example2/exercise_2/P
eval mpirun $smeagol < input.fdf > out

cd $tdir/example2/exercise_2/AP
eval mpirun $smeagol < input.fdf > out

cd $tdir/example3
eval mpirun ~/bin/$smeagol < input.fdf > out

cd $tdir/example3/exercise_1
eval mpirun ~/bin/$smeagol < input.fdf > out

cd $tdir/example3/exercise_2
eval mpirun ~/bin/$smeagol < input.fdf > out

cd $tdir/example5
eval mpirun ~/bin/$smeagol < input.fdf > out

cd $tdir/example5/exercise_1
eval mpirun ~/bin/$smeagol < input.fdf > out


