#!/bin/bash
# mpppcadd - add ppc arch to PKGBUILD

# Check if there is a PKGBUILD in current directory
if [ ! -f PKGBUILD ]; then
	echo "==> No PKGBUILD in directory"
	exit 1
fi

if (grep ^arch PKGBUILD | grep -o any )
	then exit 0
fi

# Test if ppc arch is already in PKGBUILD
ppctest=$(grep ^arch PKGBUILD | grep -o ppc)
if [ -n "$ppctest" ]; then
	echo " ppc architecture already in PKGBUILD"
	exit 0
fi

# Add ppc arch to PKGBUILD
sed -i -e "s/\(^arch.*\))/\1 'ppc')/g" PKGBUILD
#echo "Added 'ppc' to PKGBUILD:"
grep ^arch PKGBUILD
