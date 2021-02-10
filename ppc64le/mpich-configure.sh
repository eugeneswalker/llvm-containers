#!/bin/bash

CFLAGS="-fPIC -mcpu=powerpc64le" \
 CXXFLAGS="-fPIC -mcpu=powerpc64le" \
 FFLAGS=-fPIE \
 CC=clang \
 CXX=clang++ \
 FC=flang \
 F77=flang \
 F18_FC=gfortran \
 LDFLAGS=-Wl,-rpath=/spack-llvm/view/lib \
 ./configure \
  --prefix=/usr/local/mpich \
  --with-device=ch3 2>&1 | tee configure.txt
