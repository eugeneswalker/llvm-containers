#!/bin/bash -e

SPACK_REF=a5440305173c218ec785b0d5a2dfa8b02bb0b731 # 2021-02-05
MPICH_REF=v3.3.2 

DOCKER_BUILDKIT=1 docker build \
 -t gcr.io/ecp-e4s/ubuntu20.04-llvm-x86_64:experimental-new \
 --build-arg SPACK_REF=${SPACK_REF} \
 --build-arg MPICH_REF=${MPICH_REF} .
