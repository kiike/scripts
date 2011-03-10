#!/bin/bash 
# Helps updating pkgs

if [ -z $1 ]; then
	echo -e "upgpkg.\nUsage: upgpkg <pkg1> [pkg2]..[pkgn]"
	exit 1
fi


ABS_DIR=/home/kiike/arch/i686
SVN_DIR=/home/kiike/arch/ppc

for i in $*; do
	cd ${SVN_DIR}/$i/trunk
	diff -yr -x '.svn' -x '.git' $PWD ${ABS_DIR}/$i/trunk | less
	
	if ! [ -d src ]; then
		echo -n "Copy /var/abs/extra/$i contents here? " && read copyabs
		if [ $copyabs == "y" ]
			then
				rm *
				cp -v $ABS_DIR/$i/trunk/* $PWD
		fi

	fi

	if (svn status | grep '!'); then
		svn delete $(svn status | grep '!' | tr -d '! ')
	fi

	if (svn status | grep '?'); then
		svn add $(svn status | grep '?' | tr -d '! ')
	fi
	/usr/bin/makepkg -cisr
	
	if [ $? == 0 ]
		then
			echo -n "Push to [e]xtra or [t]esting? [e/t] " && read dest_repo
			case $dest_repo in
				t) testingpkg -m "Updated" ;;
				e) extrapkg -m "Updated" ;;
			esac
	fi

done
