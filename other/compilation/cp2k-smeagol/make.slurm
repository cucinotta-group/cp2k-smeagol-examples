#!/bin/bash

# this script needs to be run on a SCARF compute node. Request one with
#salloc -p scarf -C scarf21 -t 04:00:00 -n 32

set -euo pipefail

ROOTDIR=`pwd`"/smgl"

CP2KDIR="cp2k-private"

# a branch 'smeagol-interface-cp2k-20220210' is based on CP2K 10 source code
# a branch 'smeagol-interface-cp2k-20220907' is based on CP2K 2022
CP2K_GITBRANCH="smeagol-interface-cp2k-20220907"

SMEAGOLDIR="smeagol-private"
SMEAGOL_GITBRANCH="bugfixes"

NCPUS=32

module purge
module load GCC/10.3.0 OpenMPI/4.1.1-GCC-10.3.0 OpenBLAS/0.3.15-GCC-10.3.0

mkdir -p "$ROOTDIR"
cd "$ROOTDIR"

echo "Clonning SMEAGOL repository ..."
git clone "https://github.com/schulkov/"$SMEAGOLDIR".git"
cd "$ROOTDIR"/"$SMEAGOLDIR"
git checkout -b $SMEAGOL_GITBRANCH origin/$SMEAGOL_GITBRANCH
cd $ROOTDIR

echo "Clonning CP2K repository ..."
git clone --recursive "https://github.com/schulkov/"$CP2KDIR".git"
cd "$ROOTDIR"/"$CP2KDIR"
git checkout -b $CP2K_GITBRANCH origin/$CP2K_GITBRANCH

echo "Running CP2K toolchain (compiling libraries) ..."
cd "$ROOTDIR"/"$CP2KDIR"/tools/toolchain

# an older smeagol-interface-cp2k-20220210 branch (based on CP2K 10) needs to be compiled with
# --with-spglib=no option due to broken URL https://github.com/atztogo/spglib/archive/v1.16.2.tar.gz

./install_cp2k_toolchain.sh -j $NCPUS --with-openmpi=system --with-gcc=system --with-libxc=install --with-libint=no --with-fftw=install --with-openblas=install --with-scalapack=install --with-libxsmm=install --with-elpa=no --with-plumed=no --with-sirius=no --with-gsl=no --with-libvdwxc=no --with-spglib=install --with-hdf5=no --with-spfft=no --with-spla=no --with-cosma=no --with-libvori=no &> install.log

# modify generated arch files:
#  * append -DSMEAGOL to DFLAGS
#  * append -I'$ROOTDIR/$SMEAGOLDIR/obj' to FCFLAGS
#  * append -I'$ROOTDIR/$SMEAGOLDIR/lib' to LDFLAGS
#  * prepend -lsmeagol to LIBS

SMEAGOL_INCLUDE="$(echo "-I"'"'"$ROOTDIR/$SMEAGOLDIR/obj"'"' | perl -e '$l=<STDIN>; $l=~s/\//\\\//g; print $l;' )"
SMEAGOL_LIBDIR="$(echo "-L"'"'"$ROOTDIR/$SMEAGOLDIR/lib"'"' | perl -e '$l=<STDIN>; $l=~s/\//\\\//g; print $l;' )"
sed -e 's/^\(DFLAGS.*=.*\)/\1 -DSMEAGOL/' -e 's/^\(FCFLAGS.*=.*\)/\1 '"$SMEAGOL_INCLUDE"'/' -e 's/^\(LDFLAGS.*=.*\)/\1 '"$SMEAGOL_LIBDIR"'/' -e 's/^\(LIBS.*=\)\(.*\)/\1 -lsmeagol \2/' install/arch/local.psmp > "$ROOTDIR"/"$CP2KDIR"/arch/local.psmp

set +u
source "$ROOTDIR"/"$CP2KDIR"/tools/toolchain/install/setup
set -u

echo "Compiling SMEAGOL ..."
cd "$ROOTDIR"/"$SMEAGOLDIR"
make -j $NCPUS &> make.log

echo "Compiling CP2K ..."

cd "$ROOTDIR"/"$CP2KDIR"
make -j $NCPUS ARCH="local" VERSION="popt" &> make.log
