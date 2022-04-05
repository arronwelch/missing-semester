#!/usr/bin/bash

count=0
# ./rarely.sh &> out.txt

while [[ $? -ne 1 ]]
do
    count=$((count+1))
    bash ./rarely.sh &> out.txt
done

echo "found error after $count runs"
cat out.txt
