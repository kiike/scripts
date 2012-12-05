#!/bin/zsh
# empty.sh, a really dangerous script to zero files and directories.

if [ -d "$1" ]; then
	cd "$1"
	echo "Current dir: $(pwd)"
	echo "Found those files: $(ls * **/*)"
	echo "Press Enter to continue, or Ctrl+C to abort."
	read
	for i in * **/*; do
		echo -n "Emptying $i..."
		echo "" > "$i"
	done
	echo "Done."
elif [ -f "$1" ]; then
	echo "Empty $1? (Ctrl+C to abort)"
	read
	echo "" > "$1"
else
	exit 1
fi
