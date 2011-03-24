#!/bin/bash 
# Helps updating pkgs


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
		
	if ! [ -d src ]; then
		if [[ $copy == "true" ]]
			then	rm *
				cp -v $i686_DIR/$1/trunk/* $PWD

			else	diff --left-column -yr -x '.svn' -x '.git' $PWD ${i686_DIR}/$1/trunk | less
				echo -n "Copy /var/abs/extra/$1/trunk contents here? "
				read copyabs
				if [ $copyabs == "y" ]
					then	rm *
						cp -v $i686_DIR/$1/trunk/* $PWD
				fi
		fi

	fi

	if [ -d src ] || [ -d pkg ]; then
		rm -rf src pkg
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

i686_DIR=/var/abs/i686
PPC_DIR=/var/abs/ppc

while true; do
	case $1 in
		-d)	docheckdeps=true
			shift ;;
		-t)	totesting=true
			shift ;;
		-e)	toextra=true
			shift ;;
		-c)	copy=true
			shift ;;
		*)	break ;;
	esac
done

if [ -z $1 ]; then
	echo -e "upgpkg.\nUsage: upgpkg [-d] <pkg1> [pkg2]..[pkgn]"
	echo "   -d		checks if dependencies are up-to-date"
	exit 1
fi

for i in $*
	do upgradepkg $1
	shift
done

