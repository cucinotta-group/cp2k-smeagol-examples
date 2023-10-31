#!/bin/bash
#SBATCH -J smeagol           # job name
#SBATCH -o run.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p development     # queue (partition) -- normal, development, etc.
#SBATCH -t 00:10:00        # run time (hh:mm:ss) - 1.5 hours
ibrun ~/bin/smeagol < input.fdf > out 2> err             # run the MPI executable named a.out

