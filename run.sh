#!/usr/bin/env bash

BASENAME=$1

CPP/7zip/Bundles/Alone/b/g/7za b > "${BASENAME}.txt"
cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 5 > "${BASENAME}_compress.txt"
cat ${BASENAME}.txt | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f 10 > "${BASENAME}_decompress.txt"
