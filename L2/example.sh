#!/bin/bash

echo "Starting program ar $(date)"

echo "Running program $0 with $# arguments with pid $$"

for file in "$@";do
	mycmd=$(grep foobar "$file" > /dev/null 2> /dev/null)
	# When pattern is not found, grep has exit status 1
	# We redirect STDOUT and STDERR to a null register since we do not care about them
	if [[ $mycmd -ne 0 ]]; then
		echo "File $file does not have any foobar, adding one"
		echo "# foobar" >> "$file"
	fi
done
