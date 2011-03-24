#!/bin/bash
#
# GetDeps by Enric Morales. Uncopyrighted 2011.
#
# This script gets the dependencies of an Arch Linux PKGBUILD.
# It is useful for making a package will be completely up-to-date.

SVN_DIR="/var/abs/i686"


function getdeps() {
if [ -f ${SVN_DIR}/$1/trunk/PKGBUILD ]
	then	source ${SVN_DIR}/$1/trunk/PKGBUILD
		#echo "$pkgname v${pkgver}-${pkgrel} runtime dependencies:" 1>&2 
		for rundeps in ${depends[@]}; do echo $rundeps | tr '\n' ' '; done
		for makedeps in ${makedepends[@]}; do echo $makedeps | tr '\n' ' '; done
fi

}

for i in $*; do getdeps $i; done
		
