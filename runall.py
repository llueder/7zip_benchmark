#!/bin/python

import os

THREADS=4
CORE_GROUPs=[0, 1]
MARCHs=["native", "tremont", "alderlake", "zenver4"]
MTUNEs=["native", "tremont", "alderlake", "zenver4"]
OPT_LVLs=["0", "1", "2", "3"]

with open("output.txt", 'w') as fhandle_out:
    results = {}
    fhandle_out.write("threads | core group | opt | march | mtune | compress | decompress\n")

    for OPT_LVL in OPT_LVLs:
        for MARCH in MARCHs:
            for MTUNE in MTUNEs:
                call = f'make -E "THREADS={THREADS}" -E "CORE_GROUP={CORE_GROUP}" -E "OPT_LVL={OPT_LVL}" -E "MARCH={MARCH}" -E "MTUNE={MTUNE}" build'
                print(call)
                os.system(call)

                for CORE_GROUP in CORE_GROUPs:
                    call = f'make -E "THREADS={THREADS}" -E "CORE_GROUP={CORE_GROUP}" -E "OPT_LVL={OPT_LVL}" -E "MARCH={MARCH}" -E "MTUNE={MTUNE}" run_nobuild'
                    print(call)
                    os.system(call)

                    BASENAME=f"/tmp/7zip_bench_{THREADS}_{CORE_GROUP}_{MARCH}_{MTUNE}_O{OPT_LVL}"
                    compress = None
                    decompress = None
                    try:
                        with open(BASENAME + "_compress.txt", 'r') as fhandle_c:
                            compress = int(fhandle_c.readline())
                        with open(BASENAME + "_decompress.txt", 'r') as fhandle_d:
                            decompress = int(fhandle_d.readline())
                    except FileNotFoundError:
                        pass

                    fhandle_out.write(f"{THREADS} | {CORE_GROUP} | {OPT_LVL} | {MARCH} | {MTUNE} | {compress} | {decompress}\n")
