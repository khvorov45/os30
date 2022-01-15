#!/bin/sh
gcc mkfloppy/mkfloppy.c -g -DP_USE_POSIX -D_GNU_SOURCE -o build/mkfloppy
nasm os/os.S -o build/os.bin
./build/mkfloppy -b build/os.bin build/os.img
echo done
