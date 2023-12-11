# set these variables in the make call!
# THREADS		number of threads to be used
# no hyperthreading, both groups with the same number of cores
# CORE_GROUP	0 or 1
# MARCH			accecptable string for gcc/clang
# MTUNE			accecptable string for gcc/clang
# OPT_LVL		0-3

ifndef THREADS
error
else ifndef CORE_GROUP
error
else ifndef MARCH
error
else ifndef MTUNE
error
else ifndef OPT_LVL
error
endif

CORE_GROUP_0=0,2,4,6,8,10 # performance cores TODO check that these really are the distinct hw cores, not hyperthreading
CORE_GROUP_1=12-17 # efficiency cires

.PHONY: set_threads set_march set_mtune set_opt

set_threads:
	sed -i -e "s/UInt32 numThreadsSpecified = .*;/UInt32 numThreadsSpecified = ${THREADS};/" CPP/7zip/UI/Common/Bench.cpp

set_march:
	sed -i -e "s/MTUNE=.*/MTUNE=${MTUNE}/" CPP/7zip/7zip_gcc.mak

set_mtune:
	sed -i -e "s/MARCH=.*/MARCH=${MARCH}/" CPP/7zip/7zip_gcc.mak

set_opt:
	sed -i -e "s/OPT_LVL=.*/OPT_LVL=${OPT_LVL}/" CPP/7zip/7zip_gcc.mak

build: set_threads set_march set_mtune set_opt
	make -C CPP/7zip/Bundles/Alone -j -f ../../cmpl_gcc.mak clean
	make -C CPP/7zip/Bundles/Alone -j -f ../../cmpl_gcc.mak


ifeq (${CORE_GROUP}, 0)
CORE_GROUP_EXPANDED=${CORE_GROUP_0}
else ifeq (${CORE_GROUP}, 1)
CORE_GROUP_EXPANDED=${CORE_GROUP_1}
else
	echo "error"
endif

BASENAME=/tmp/7zip_bench_${THREADS}_${CORE_GROUP}_${MARCH}_${MTUNE}_O${OPT_LVL}
run_nobuild:
	taskset -c ${CORE_GROUP_EXPANDED} CPP/7zip/Bundles/Alone/b/g/7za b > ${BASENAME}.txt
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 5 > ${BASENAME}_compress.txt
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 10 > ${BASENAME}_decompress.txt

run: build
	taskset -c ${CORE_GROUP_EXPANDED} CPP/7zip/Bundles/Alone/b/g/7za b > ${BASENAME}.txt
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 5 > ${BASENAME}_compress.txt
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 10 > ${BASENAME}_decompress.txt
