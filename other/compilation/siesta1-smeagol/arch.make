SIESTA_ARCH=mpif90
#
FC=mpif90
FC_ASIS=$(FC)
CXX=icc
CXX_FLAGS=-O0

#
#FFLAGS=-O0 -g -traceback  -check -qopenmp
#FFLAGS=-O2
#FFLAGS=-O0 -g -traceback -qopenmp -check


#NODEVELOP=N
THREADED=T
ifdef THREADED
  FFLAGS=-O3 -check bounds -fp-model strict
#  FFLAGS=-Og -g -check bounds -traceback -fp-model strict
#  FFLAGS=-O0 -qopenmp -g -traceback -check 
#  FFLAGS=-O3 -qopenmp
#  FFLAGS=-O3 -fopenmp 
else
   FFLAGS=-O0 -g -traceback -check
#  FFLAGS=-O3
endif

#
LDFLAGS=$(FFLAGS) 
#
COMP_LIBS=
TRANSPORTFLAGS= -c $(FFLAGS)
#
SOURCE_DIR= ../
EXEC = smeagol-1.2_csg
#
DEFS_CDF=
MPI_INTERFACE=libmpi_f90.a
#
#DEFS_MPI=-DMPI -DNoMPIInPlace
DEFS_MPI=-DMPI
#

#MKLROOT=/ichec/packages/intel/2018u4/compilers_and_libraries_2018.5.274/linux/mkl
#MKLROOT=/rdsgpfs/general/apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl/
#MKLROOT= /apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl
MKLROOT= /shared/ucl/apps/intel/2020/compilers_and_libraries_2020.0.166/linux/mkl



ifdef THREADED
#  MPI_DIR=/home/support/apps/cports/rhel-6.x86_64/intel12.1.3/openmpi/1.7.3
  MPI_DIR=/lustre/shared/ucl/apps/intel/2020/compilers_and_libraries_2020.0.166/
  MKL_LIB  = ${MKLROOT}/lib/intel64
# LIBS    += $(MKL_LIB)/libmkl_scalapack_lp64.a -Wl,--start-group \
#          ${MKL_LIB}/libmkl_blacs_openmpi_lp64.a  \
#          $(MKL_LIB)/libmkl_intel_lp64.a ${MKL_LIB}/libmkl_sequential.a \
#          $(MKL_LIB)/libmkl_core.a -Wl,--end-group \
#          -lpthread -lstdc++
# LIBS=-lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 -lmkl_intel_thread -lmkl_intel_lp64 -lmkl_core -lpthread -lstdc++ 
LIBS=${MKLROOT}/lib/intel64/libmkl_scalapack_lp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_blacs_intelmpi_lp64.a -Wl,--end-group -lpthread -lm -ldl
else
#  MPI_DIR=/home/support/apps/cports/rhel-6.x86_64/intel12.1.3/openmpi/1.7.3
  MPI_DIR=/lustre/shared/ucl/apps/intel/2020/compilers_and_libraries_2020.0.166/
#  LIBS=-lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -L$(MPI_LIBDIR) -lmpi
#MKL_LIB  = ${MKLROOT}/lib/intel64
#  LIBS=-lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lstdc++ 
#LIBS    += $(MKL_LIB)/libmkl_scalapack_lp64.a -Wl,--start-group \
#           ${MKL_LIB}/libmkl_blacs_openmpi_lp64.a  \
#           $(MKL_LIB)/libmkl_intel_lp64.a ${MKL_LIB}/libmkl_sequential.a \
#           $(MKL_LIB)/libmkl_core.a -Wl,--end-group \
#            -lstdc++
#
LIBS=${MKLROOT}/lib/intel64/libmkl_scalapack_lp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_blacs_intelmpi_lp64.a -Wl,--end-group -lpthread -lm -ldl
endif

MPI_INCLUDE=$(MPI_DIR)/include
MPI_LIBDIR=$(MPI_DIR)/lib


#libmkl_scalapack_lp64.so => /apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl/lib/intel64/libmkl_scalapack_lp64.so (0x00002b929b6fb000)
#	libmkl_intel_lp64.so => /apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl/lib/intel64/libmkl_intel_lp64.so (0x00002b929bfd8000)
#	libmkl_core.so => /apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl/lib/intel64/libmkl_core.so (0x00002b929ca71000)
#	libmkl_sequential.so => /apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl/lib/intel64/libmkl_sequential.so (0x00002b929eba4000)
#	libmkl_blacs_intelmpi_lp64.so => /apps/intel/2017.6/compilers_and_libraries_2017.6.256/linux/mkl/lib/intel64/libmkl_blacs_intelmpi_lp64.so (0x00002b929fe0d000)
###	libm.so.6 => /lib64/libm.so.6 (0x00002b92a004e000)
#	libmpi.so.12 => /apps/mpi/intel/2018.1.163/lib/libmpi.so.12 (0x00002b92a0350000)
#	libmpifort.so.12 => /apps/mpi/intel/2018.1.163/lib/libmpifort.so.12 (0x00002b92a0fd5000)
#	libpthread.so.0 => /lib64/libpthread.so.0 (0x00002b92a137e000)
#	libc.so.6 => /lib64/libc.so.6 (0x00002b92a159a000)
#	libgcc_s.so.1 => /apps/intel/2017.6/clck/2017.2.019/lib/intel64/libgcc_s.so.1 (0x00002b92a1967000)
#	libdl.so.2 => /lib64/libdl.so.2 (0x00002b92a1b7d000)
#	/lib64/ld-linux-x86-64.so.2 (0x00002b929b4d7000)
#	librt.so.1 => /lib64/librt.so.1 (0x00002b92a1d81000)




RANLIB=echo
SYS=bsd
DEFS= $(DEFS_CDF) $(DEFS_MPI)


EXT_LIBS=extlibs.a

bands.o: FFLAGS=-O2 
#bands.o: FFLAGS+=-O2 

#siesta.o: siesta.F
#	$(FC) -c -O0 -DMPI siesta.F
#
.F.o:
	$(FC) -c $(FFLAGS)  $(DEFS) $<
.f.o:
	$(FC) -c $(FFLAGS)   $<
.F90.o:
	$(FC) -c $(FFLAGS)  $(DEFS) $<
.f90.o:
	$(FC) -c $(FFLAGS)   $<		    
#.cxx.o:
#	$(CXX) -c $(CXX_FLAGS)   $<		    
#


