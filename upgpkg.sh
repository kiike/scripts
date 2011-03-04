#!/bin/bash 
# Helps updating pkgs

ABS_DIR=/var/abs
SVN_DIR=/home/kiike/archppc

for i in $@; do
	cd ${SVN_DIR}/$i/trunk
	diff -r . ${ABS_DIR}/extra/$i/
	echo -n "Copy /var/abs/extra/$i contents here? " && read goforit
	if [ $goforit == "y" ] || [ -z $goforit ]
		then
			cp /var/abs/extra/$i/* .
		else
			bash
	fi
	svn status
	sleep 2s
	echo "OK, there we go..."
	makepkg -crs
	if [ $? == 0 ]
		then
			echo -n "Push to [e]xtra or [t]esting? [e/t] " && read dest_repo
			case $dest_repo in
				t) testingpkg -m "Updated" ;;
				e) extrapkg -m "Updated" ;;
			esac
	fi

	shift
done
