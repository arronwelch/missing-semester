#!/bin/bash
# bash ./rarely.sh

n=$(( RANDOM % 100 ))
# n=42

if [[ n -eq 42 ]]; then
echo "Something went wrong"
>&2 echo "The error was using magic numbers"
exit 1
fi

echo "Everthing went according to plan"