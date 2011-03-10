#!/bin/sh

function checkver() {
	localver=$(pacman -Q $1 | awk '{print $2}')

	if [ -f /var/abs/community/$i/PKGBUILD ]
		then source /var/abs/community/$1/PKGBUILD
		else return
	fi

	if ! [ $localver == ${pkgver}-${pkgrel} ]; then
			echo "$i ($localver -> ${pkgver}-${pkgrel})"
	fi
}

for i in $(pacman -Qmq); do
	checkver $i
done
