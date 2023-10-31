#!/bin/bash
#SBATCH -J smeagol           # job name
#SBATCH -o run.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 64              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -t 5:00:00        # run time (hh:mm:ss) - 1.5 hours
ibrun ~/bin/smeagol < input.fdf > out 2> err             # run the MPI executable named a.out

