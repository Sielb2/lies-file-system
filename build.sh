#!/bin/bash
nasm -felf64 home.asm
ld home.o -o home
echo "build completed"
cd files
counter=1
while [ $counter -le 5 ]
do
#incase there are no files set
touch "file$counter.txt"
((counter++))
done
