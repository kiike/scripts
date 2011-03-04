#!/bin/bash
#
#	absup
#	=========
#	Checks svn packages updates against abs
#
#	Uncopyrighted. Enric Morales <geekingaround@enric.me> 2011


SVN_DIR=/home/kiike/archppc
ABS_DIR=/var/abs/

function check_package_upgrade() {
	SVN_PKGBUILD="${SVN_DIR}/$i/trunk/PKGBUILD"
	if [ -f ${SVN_PKGBUILD} ]
		then
			source $SVN_PKGBUILD
			SVNVER=$pkgver #-$pkgrel
		else
			return 1
	fi

	ABS_PKGBUILD="${ABS_DIR}/extra/$i/PKGBUILD"
	source $ABS_PKGBUILD
	ABSVER=$pkgver #-$pkgrel

	if ! [ $ABSVER == $SVNVER ]
		then
			if [ "$quiet" == "true" ]
				then
					echo -n "$1 "
				else
					echo "$1" "($curver -> $absver)"
			fi
			return 2
		else
			return 0
	fi
}


if [ -z $1 ] || [ -z $2 ] ; then
	echo "absup"
	echo "Usage: $0 [-q] all		checks all PKGBUILD updates in $SVN_DIR against $ABS_DIR"
	echo "               <pkg1>..<pkgn>	just check the given packages."
	echo "               installed		checks the currently installed packages"
	echo ""
	echo " the -q switch won't output version numbers, just updatable packages."
	exit 255
fi


test "$1" == "-q" && quiet="true"

if [ $1 == "installed" ] || [ $2 == "installed" ]; then
	for i in $(pacman -Qq); do
		check_package_upgrade $i 
	done
	exit 0
fi

if [ $1 == "all" ] || [ $2 == "all" ]
	then
		for i in $(ls ${ABS_DIR}/extra); do
			check_package_upgrade $i 
		done
	else
		for i in $*; do
			check_package_upgrade $i
		done

fi

