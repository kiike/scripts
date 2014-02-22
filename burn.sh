#!/bin/bash
# Burns current directory to a disc

FOLDER_NAME=$(basename $PWD)

calc_size() {
	mkisofs -quiet -print-size -frlJ -A
}

mkisofs -frlJ -A "$FOLDER_NAME" . | \
	cdrecord tsize=$(calc_size) dev=/dev/sr0 -
