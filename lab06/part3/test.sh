#!/bin/bash

make clean all

> output.txt

# ALGORITHM 1
printf "\n\n\n"
for ((i=256; i<=2048; i+=256))
do
    ./matrix_math 1 $i
    printf "\n"
    ./matrix_math 1 $i >> output.txt
    echo "\n" >> output.txt
done

echo "\n\n\n" >> output.txt

# ALGORITHM 2
printf "\n\n\n"
for ((i=256; i<=2048; i+=256))
do
    ./matrix_math 2 $i
    printf "\n"
    ./matrix_math 2 $i >> output.txt
    echo "\n" >> output.txt
done


# STORE FLOPS ONLY IN TXT FILE
grep Floating-point output.txt > FLOPS.txt