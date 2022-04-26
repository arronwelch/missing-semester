#!/usr/bin/env  bash
for R in $(seq 0 20 255); do
	for G in $(seq 0 20 255); do
		for B in $(seq 0 20 255); do
			printf "\e[38;2;${R};${G};${B}m█\e[0m";#ctrl+i;ctrl+v;u2588
		done
	done
done
