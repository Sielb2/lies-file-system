#!/bin/bash
echo "useless notice that the build is starting!!!"
nasm -felf64 home.asm
ld home.o -o home
echo "build completed"
cd ..
counter=1
while [ $counter -le 5 ]
do
touch "file$counter.txt"
((counter++))
done
echo "Created 5 starting files for the file system"
