#!/usr/bin/env bash

THREADS=$1
MARCH=$2
MTUNE=$3
OPT_LVL=$4
MAKEFILE=$5

sed -i -e "s/UInt32 numThreadsSpecified = .*;/UInt32 numThreadsSpecified = ${THREADS};/" CPP/7zip/UI/Common/Bench.cpp
sed -i -e "s/MTUNE=.*/MTUNE=${MTUNE}/" CPP/7zip/7zip_gcc.mak
sed -i -e "s/MARCH=.*/MARCH=${MARCH}/" CPP/7zip/7zip_gcc.mak
sed -i -e "s/OPT_LVL=.*/OPT_LVL=${OPT_LVL}/" CPP/7zip/7zip_gcc.mak

make -C CPP/7zip/Bundles/Alone -j -f ../../${MAKEFILE} clean
make -C CPP/7zip/Bundles/Alone -j -f ../../${MAKEFILE}
