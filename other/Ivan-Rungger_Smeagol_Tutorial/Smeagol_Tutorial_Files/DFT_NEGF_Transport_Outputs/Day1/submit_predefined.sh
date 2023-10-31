#!/bin/bash
#SBATCH -J smeagol           # job name
#SBATCH -o run.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 8              # total number of mpi tasks requested
#SBATCH -p development     # queue (partition) -- normal, development, etc.
#SBATCH -t 00:30:00        # run time (hh:mm:ss) - 1.5 hours

#mpirun ~/bin/smeagol-1.2_csg_debug < input.fdf > out 2> err             # run the MPI executable named a.out


tdir=/home1/02598/amaury/Tutorial_Tests/DFT_NEGF_Transport_Run_All_Day1

cd $tdir/leads-1D/
ibrun -n 1 -o 1 ~/bin/smeagol < input.fdf > out 2> err
cp bulk* *HST *DM ../example1
cp bulk* *HST *DM ../example1/exercise_1
cp bulk* *HST *DM ../example1/exercise_2
cp bulk* *HST *DM ../example1/exercise_3

cd $tdir/leads-1D/spinpolarized
ibrun -n 1 -o 1 ~/bin/smeagol < input.fdf > out 2> err
cp bulk* *HST *DM ../../example2
cp bulk* *HST *DM ../../example2/exercise_1
cp bulk* *HST *DM ../../example2/exercise_2/P
cp bulk* *HST *DM ../../example2/exercise_2/AP

cd $tdir/leads-2D/
ibrun -n 1 -o 1 ~/bin/smeagol < input.fdf > out 2> err
cp bulk* *HST *DM ../example3
cp bulk* *HST *DM ../example3/exercise_1
cp bulk* *HST *DM ../example3/exercise_2
cp bulk* *HST *DM ../example4
cp bulk* *HST *DM ../example5
cp bulk* *HST *DM ../example5/exercise_1

cd $tdir/example1
ibrun -n 4 -o 1 ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example1/exercise_1
ibrun -n 4 -o 1 ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example1/exercise_2
ibrun -n 4 -o 1 ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example1/exercise_3
ibrun -n 4 -o 1 ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example2
ibrun -n 4 -o 1 ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example2/exercise_1
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example2/exercise_2/P
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example2/exercise_2/AP
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example3
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example3/exercise_1
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example3/exercise_2
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example5
ibrun ~/bin/smeagol < input.fdf > out 2> err

cd $tdir/example5/exercise_1
ibrun ~/bin/smeagol < input.fdf > out 2> err


