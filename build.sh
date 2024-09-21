#!/bin/bash
sudo apt update
echo "useless notice that the build is starting!!!"
cd
nasm -felf64 home.asm
ld home.o -o home
echo "build completed"

counter=1
while [ $counter -le 5 ]
do
        touch "file$counter.txt"
        ((counter++))
done
echo "Created 5 starting files for the file system"
