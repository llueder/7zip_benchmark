# set these variables in the make call!
# THREADS		number of threads to be used
# MARCH			accecptable string for gcc/clang
# MTUNE			accecptable string for gcc/clang
# OPT_LVL		0-3

ifndef THREADS
error
else ifndef MARCH
error
else ifndef MTUNE
error
else ifndef OPT_LVL
error
else ifndef BASENAME
error
endif


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

run_nobuild:
	CPP/7zip/Bundles/Alone/b/g/7za b > "${BASENAME}.txt"
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 5 > "${BASENAME}_compress.txt"
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 10 > "${BASENAME}_decompress.txt"

run: build
	CPP/7zip/Bundles/Alone/b/g/7za b > "${BASENAME}.txt"
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 5 > "${BASENAME}_compress.txt"
	cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 10 > "${BASENAME}_decompress.txt"
