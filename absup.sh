#!/bin/bash

##########################################################
# absup.sh by Enric Morales <geekingaround@enric.me>
#
# This script checks for a package upgrade against ABS
#
# Version 0.1. Released under the Public Domain, 2010.

if [ ! -n "$1" ]; then
   echo "ERROR: Must provide an argument."
   echo "Usage: $0 <package_name>     to check a single package"
   echo "       $0 all                to check all the installed packages"
   exit 1
fi

where_in_abs () {
test -f /var/abs/core/$1/PKGBUILD && pkgbuild=/var/abs/core/$1/PKGBUILD
test -f /var/abs/extra/$1/PKGBUILD && pkgbuild=/var/abs/extra/$1/PKGBUILD
test -f /var/abs/community/$1/PKGBUILD && pkgbuild=/var/abs/community/$1/PKGBUILD
test ! -z $pkgbuild
}

get_versions () {
curver=$(pacman -Q $1 | awk ' { print $2 } ' | cut -d "-" -f 1)
absver=$(grep -m 1 pkgver $pkgbuild | sed "s/pkgver=//")
[[ $curver < $absver ]] && echo -n "$1 "
}

if [[ $1 == "all" ]]
  then 
    for i in $(pacman -Qq | tr "\n" ' ')
      do ( where_in_abs $i && get_versions $i )
    done
  else
    where_in_abs $1 && get_versions $1
fi
