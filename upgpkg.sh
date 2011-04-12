#!/bin/bash 
# Helps updating pkgs

function printusage() {
	echo "upgpkg usage:	upgpkg [-c] [-d] [-e|-t] <pkg_name1> ... [pkg_name99]"
	echo "   -d		checks if dependencies are up-to-date"
	echo "   -y		updates the build files (PKGBUILD, patches, etc) without confirmation"
	echo "   -e		commits to extra after a successful build"
	echo "   -t		commits to testing after a successful build"
	echo "   -c		commits to core after a successful build"
	exit 1

}

function checkdeps() {
	echo -n "==> Checking dependencies... "
	if ! absup $(getdeps $i) > /dev/null
		then
			echo -e "\nERROR: Outdated dependencies for $i:"
			absup $(getdeps $i)
			exit 1
		else
			echo "Dependencies up-to-date."
	fi
}

function pushtorepos() {
	[[ $totesting == "true" ]] && testingpkg -m 'Updated'
	[[ $toextra == "true" ]] && extrapkg -m 'Updated'
	if [ -z $toextra ] && [ -z $totesting ]; then
		echo -n "Push to [e]xtra or [t]esting? [e/t] " && read dest_repo
		case $dest_repo in
			t) testingpkg -m "Updated" ;;
			e) extrapkg -m "Updated" ;;
		esac
	fi
}

function upgradepkg() {
	[[ $docheckdeps == "true" ]] && checkdeps
	cd ${PPC_DIR}/$1/trunk

	if [ -d src ] || [ -d pkg ]; then
		rm -rf src pkg
	fi

	#test -f ${i686_DIR}/core/$i/PKGBUILD && i686_PKG_DIR="${i686_DIR}/core/$i/"
	#test -f ${i686_DIR}/extra/$i/PKGBUILD && i686_PKG_DIR="${i686_DIR}/extra/$i/"
	#test -f ${i686_DIR}/testing/$i/PKGBUILD && i686_PKG_DIR="${i686_DIR}/testing/$i/"

	test -f ${i686_DIR}/$i/trunk/PKGBUILD && i686_PKG_DIR="${i686_DIR}/$i/trunk"	

	if [[ $copy == "true" ]]
		then	rm *
			cp -v $i686_PKG_DIR/* $PWD

		else	diff --left-column -yr -x '.svn' -x '.git' $PWD ${i686_PKG_DIR}/ | less
			echo -n "==> Copy $i686_PKG_DIR contents here? "
			read copyabs
			if [ $copyabs == "y" ]
				then	rm *
					cp -v $i686_PKG_DIR/* $PWD
			fi
	fi


	if (svn status | grep '!'); then
		svn delete $(svn status | grep '!' | tr -d '! ')
	fi

	if (svn status | grep '?'); then
		svn add $(svn status | grep '?' | tr -d '? ')
	fi
	
	/usr/bin/makepkg -cisr
	
	[[ $? == 0 ]] && pushtorepos
} 

i686_DIR=~/i686
PPC_DIR=~/ppc

while true; do
	case $1 in
		-d)	docheckdeps=true
			shift ;;
		-t)	totesting=true
			shift ;;
		-e)	toextra=true
			shift ;;
		-y)	copy=true
			shift ;;
		-c)	tocore=true
			shift ;;
		*)	break ;;
	esac
done

if [[ $toextra == "true" ]] && [[ $totesting == "true" ]]
	then echo "==> ERROR: Either use -t or -e, not both."
fi

[ -z $1 ] && printusage

for i in $*
	do upgradepkg $1
	shift
done

