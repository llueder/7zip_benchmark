f = open("2023-12-11.txt", 'r')
results = {}
table = []
for line in f:
   arr = [s.strip() for s in line.split(' ')]
   threads = int(arr[0])
   grp = int(arr[2])
   opt = int(arr[4])
   march = arr[6]
   mtune = arr[8]
   compress = int(arr[10])
   decompress = int(arr[12])
   results[f"{threads} | {grp} | {opt} | {march} | {mtune}"] = (compress, decompress)
   #              0        1    2   3       4       5         6
   table.append((threads, grp, opt, march, mtune, compress, decompress))
THREADS = 0
GRP = 1
OPT = 2
MARCH = 3
MTUNE = 4
COMPRESS = 5
DECOMPRESS = 6

GRP_P = 0
GRP_E = 1

OPT_LVLS = [1,2,3]
# import json
# with open("output.json", 'w') as fhandle_json:
#     json.dump(results, fhandle_json)

print("Influence of optimization level")
print("mtune=march")
print("with native on P")
print("O: " + str([e[OPT] for e in table if e[GRP] == GRP_P and e[MARCH] == "native" and e[MTUNE] == "native"]))
print("c: " + str([e[COMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == "native" and e[MTUNE] == "native"]))
print("d: " + str([e[DECOMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == "native" and e[MTUNE] == "native"]))
print("with native on E")
print("O: " + str([e[OPT] for e in table if e[GRP] == GRP_E and e[MARCH] == "native" and e[MTUNE] == "native"]))
print("c: " + str([e[COMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == "native" and e[MTUNE] == "native"]))
print("d: " + str([e[DECOMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == "native" and e[MTUNE] == "native"]))
print("with alderlake on P")
print("O: " + str([e[OPT] for e in table if e[GRP] == GRP_P and e[MARCH] == "alderlake" and e[MTUNE] == "alderlake"]))
print("c: " + str([e[COMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == "alderlake" and e[MTUNE] == "alderlake"]))
print("d: " + str([e[DECOMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == "alderlake" and e[MTUNE] == "alderlake"]))
print("with alderlake on E")
print("O: " + str([e[OPT] for e in table if e[GRP] == GRP_E and e[MARCH] == "alderlake" and e[MTUNE] == "alderlake"]))
print("c: " + str([e[COMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == "alderlake" and e[MTUNE] == "alderlake"]))
print("d: " + str([e[DECOMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == "alderlake" and e[MTUNE] == "alderlake"]))
print("with tremont on P")
print("O: " + str([e[OPT] for e in table if e[GRP] == GRP_P and e[MARCH] == "tremont" and e[MTUNE] == "tremont"]))
print("c: " + str([e[COMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == "tremont" and e[MTUNE] == "tremont"]))
print("d: " + str([e[DECOMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == "tremont" and e[MTUNE] == "tremont"]))
print("with tremont on E")
print("O: " + str([e[OPT] for e in table if e[GRP] == GRP_E and e[MARCH] == "tremont" and e[MTUNE] == "tremont"]))
print("c: " + str([e[COMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == "tremont" and e[MTUNE] == "tremont"]))
print("d: " + str([e[DECOMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == "tremont" and e[MTUNE] == "tremont"]))

arch = ["native", "tremont", "alderlake"]
opt = ["1", "2", "3"]
compress_performance = [[e[COMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == e[MTUNE] and e[OPT]==opt] for opt in OPT_LVLS]
decompress_performance = [[e[DECOMPRESS] for e in table if e[GRP] == GRP_P and e[MARCH] == e[MTUNE] and e[OPT]==opt] for opt in OPT_LVLS]
compress_efficiency = [[e[COMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == e[MTUNE] and e[OPT]==opt] for opt in OPT_LVLS]
decompress_efficiency = [[e[DECOMPRESS] for e in table if e[GRP] == GRP_E and e[MARCH] == e[MTUNE] and e[OPT]==opt] for opt in OPT_LVLS]

import numpy as np
from matplotlib import pyplot as plt

# plt.figure()
plt.matshow(compress_performance)
plt.xticks(range(len(arch)), arch)
plt.yticks(range(len(opt)), opt)
plt.title("compress on P")

# plt.figure()
plt.matshow(decompress_performance)
plt.xticks(range(len(arch)), arch)
plt.yticks(range(len(opt)), opt)
plt.title("decompress on P")

# plt.figure()
plt.matshow(compress_efficiency)
plt.xticks(range(len(arch)), arch)
plt.yticks(range(len(opt)), opt)
plt.title("compress on E")

# plt.figure()
plt.matshow(decompress_efficiency)
plt.xticks(range(len(arch)), arch)
plt.yticks(range(len(opt)), opt)
plt.title("decompress on E")

plt.show()
