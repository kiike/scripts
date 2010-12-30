#!/bin/bash
for i in $*; do
	build_dir=$(find /var/abs/ -maxdepth 2 -type d -name "$1")
	if [ -z "$build_dir" ]
		then echo "ERROR: $1 not found in ABS" && exit 1
		else cd "$build_dir"
	fi
	
	mppcadd
	makepkg -cirs
	shift
done
