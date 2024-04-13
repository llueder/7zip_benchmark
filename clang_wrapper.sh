#! /bin/bash

fwd_vars=

while (( "$#" ))
do
    var=$1
    # echo $var
    if [[ $var == "-o" ]]; then
        shift
        out_file=$1
        # echo "outfile"
        is_param=false
    elif [[ $var == -* ]]; then
        is_param=true
        fwd_vars="$fwd_vars $var"
        # echo "-"
    elif [[ $is_param == true ]]; then
        fwd_vars="$fwd_vars $var"
        # echo "param"
        is_param=false
    else
        in_file=$var
        # echo "input"
        is_param=false
    fi
    shift
done

echo "in: $in_file, out: $out_file"

OPT=/home/llueder/Masterarbeit/switcher/test_project/../llvm/build/bin/opt

out_file_stem=${out_file%.*}
clang $fwd_vars -emit-llvm $in_file -o ${out_file_stem}.bc
$OPT --passes=bs-global,bs-dispatch --variant=common ${out_file_stem}.bc -S -o ${out_file_stem}_common.ll
$OPT --passes=bs-global,bs-dispatch --variant=A ${out_file_stem}.bc -S -o ${out_file_stem}_A.ll
$OPT --passes=bs-global,bs-dispatch --variant=B ${out_file_stem}.bc -S -o ${out_file_stem}_B.ll
# opt ${out_file_stem}.bc -o ${out_file_stem}_common.bc
# opt ${out_file_stem}.bc -o ${out_file_stem}_A.bc
# opt ${out_file_stem}.bc -o ${out_file_stem}_B.bc
clang $fwd_vars -mtune=raptorlake ${out_file_stem}_common.ll -o ${out_file_stem}_common.o
clang $fwd_vars -mtune=raptorlake ${out_file_stem}_A.ll -o ${out_file_stem}_A.o
clang $fwd_vars -mtune=tremont ${out_file_stem}_B.ll -o ${out_file_stem}_B.o
ld -relocatable ${out_file_stem}_common.o ${out_file_stem}_A.o ${out_file_stem}_B.o -o ${out_file_stem}.o
