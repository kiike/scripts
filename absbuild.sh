#!/bin/bash
for i in $*; do
	if [ -f /var/abs/community/$i/PKGBUILD ]
		then	cd /var/abs/community/$i/
			mppcadd
			makepkg -cirs
		else 	echo $i dir not found
	fi
done
