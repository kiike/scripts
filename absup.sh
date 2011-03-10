#!/bin/bash
#
#	absup
#	=========
#	Checks svn packages updates against abs
#
#	Uncopyrighted. Enric Morales <geekingaround@enric.me> 2011


PPC_DIR=/home/kiike/arch/ppc
i686_DIR=/home/kiike/arch/i686

function check_package_upgrade() {
	PPC_PKGBUILD="${PPC_DIR}/$i/trunk/PKGBUILD"
	if [ -f ${PPC_PKGBUILD} ]
		then
			source $PPC_PKGBUILD
			PPCVER=$pkgver-$pkgrel
		else
			return 1
	fi

	i686_PKGBUILD="${i686_DIR}/$i/trunk/PKGBUILD"
	source $i686_PKGBUILD
	i686VER=$pkgver-$pkgrel

	if ! [ $PPCVER == $i686VER ]
		then
			if [ "$quiet" == "true" ]
				then
					echo -n "$1 "
				else
					echo "$1" "($PPCVER -> $i686VER)"
			fi
			return 2
		else
			return 0
	fi
}


if [ -z $1 ] || ( [ $1 == "-q" ] && [ -z $2 ] ); then
	echo "absup"
	echo "Usage: $0 [-q] all		checks all PKGBUILD updates in $SVN_DIR against $ABS_DIR"
	echo "               <pkg1>..<pkgn>	just check the given packages."
	echo "               installed		checks the currently installed packages"
	echo ""
	echo " the -q switch won't output version numbers, just updatable packages."
	exit 255
fi


test "$1" == "-q" && quiet="true"

if [ $1 == "installed" ] || ( [ $1 == "-q" ] && [ $2 == "installed" ] ); then
	for i in $(pacman -Qq); do
		check_package_upgrade $i 
	done
	exit 0
fi

if [ $1 == "all" ] || ( [ $1 == "-q" ] && [ $2 == "all" ] )
	then
		for i in $(ls ${i686_DIR}); do
			check_package_upgrade $i 
		done
	else
		for i in $*; do
			check_package_upgrade $i
		done

fi

