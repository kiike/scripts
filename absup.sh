#!/bin/bash

##########################################################
# absup.sh by Enric Morales <geekingaround@enric.me>
#
# This script checks for a package upgrade against ABS
#
# Version 0.3 Released under the Public Domain, 2010.

if [ ! -n "$1" ]; then
	echo "ERROR: Must provide an argument."
	echo "Usage: $0 [options] <package_names>	to check specified packages (separated by spaces)"
	echo "       $0 [options] all			to check all the installed packages"
	echo "Options: -q				outputs in quiet mode"

	exit 1
fi

test "$1" == "-q" && quiet="true"

where_in_abs() {
# DISABLE CORE PACKAGES TESTING test -f /var/abs/core/$1/PKGBUILD && pkgbuild=/var/abs/core/$1/PKGBUILD
test -f /var/abs/extra/$1/PKGBUILD && pkgbuild=/var/abs/extra/$1/PKGBUILD && return 0
test -f /var/abs/community/$1/PKGBUILD && pkgbuild=/var/abs/community/$1/PKGBUILD && return 0
return 1
}

get_versions() {
curver=$(pacman -Q $1 | awk ' { print $2 } ' )
absver=$(grep -m 1 pkgver $pkgbuild | sed "s/pkgver=//")-$(grep -m 1 pkgrel $pkgbuild | sed "s/pkgrel=//")

if [[ $curver < $absver ]]; then
	test "$quiet" == "true" && echo -n "$1 " || echo "$1" "($curver -> $absver)"
fi

}

if [ "$1" == "all" ] || [ "$2" == "all" ]
  then
	for i in $(pacman -Qq | tr "\n" ' ')
		do where_in_abs $i && get_versions $i
	done
  else
	for i in $*; do
		where_in_abs $i && get_versions $i
	done
fi
