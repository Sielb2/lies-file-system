#!/bin/bash
echo "useless notice that the build is starting!!!"
nasm -felf64 home.asm
ld home.o -o home
echo "build completed"
