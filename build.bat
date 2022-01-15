@echo off
cl -nologo mkfloppy/mkfloppy.c -Z7 -DP_USE_WINDOWS -Fe:build/mkfloppy.exe -Fo:build/mkfloppy.obj
nasm os/os.S -o build/os.bin
.\build\mkfloppy.exe -b build/os.bin build/os.img
echo done
