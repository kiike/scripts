#!/bin/bash 
# Helps updating PKGBUILDs against different Arch Linux projects
# Uncopyrighted 2011 Enric Morales

# {{ Global variables
ORIGIN_DIR=/home/kiike/i686
DEST_DIR=/home/kiike/ppc
#}}

function printusage() {
	echo "upgpkg usage:"
	echo "  upgpkg up [OPTIONS] <pkg1> .. <pkg 99>	upgrades the given packages"
	echo "	upgpkg check [pkg1] .. [pkg99]		checks all or given packages for upgrades"
	echo "	upgpkg deps <pkg1> .. [pkg99]		prints the dependencies of the given packages"
	echo ""
	echo "	OPTIONS"
	echo "	-d		check dependencies of the given packages for upgrades"
	echo "	-c, -t, -e	pushes to [core], [testing] or [extra] respectively"

	exit 1

}

function deps() {
	TEMPFILE=$(mktmp upgpkg.XXXXXX)
	echo -n "==> Checking dependencies... "
	if ! upgpkg check $(upgpkg deps $1) > $TEMPFILE
		then
			echo -e "\nERROR: Outdated dependencies for $i:"
			cat $TEMP	
			exit 1
		else
			echo "Dependencies up-to-date."
	fi
	rm $TEMPFILE
}

function check() {
	DEST_PKGBUILD="${ORIGIN_DIR}/$i/trunk/PKGBUILD"
	ORIGIN_PKGBUILD="${DEST_DIR}/$i/trunk/PKGBUILD"

	if [ -f ${DEST_PKGBUILD} ]
			then
			source $DEST_PKGBUILD
			DEST_VER=$pkgver-$pkgrel
		else
			return 1
	fi 

	source $ORIGIN_PKGBUILD
	ORIGIN_VER=$pkgver-$pkgrel

	if [ $(vercmp $DEST_VER $ORIGIN_VER) == "-1" ]
		then
			if [ "$quiet" == "true" ]
				then
					echo -n "$1 "
				else
					echo "$1" "($DEST_VER -> $ORIGIN_VER)"
			fi
			return 2
		else
			return 0
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
			c) corepkg -m "Updated" ;;
		esac
	fi
}

function up() {
	[[ $docheckdeps == "true" ]] && checkdeps
	cd ${DEST_DIR}/$1/trunk

	if [ -d src ] || [ -d pkg ]; then
		rm -rf src pkg
	fi

	if [[ $copy == "true" ]]
		then	rm *
			cp -v $ORIGIN_DIR/* $PWD

		else	diff --left-column -yr -x '.svn' -x '.git' $PWD ${ORIGIN_DIR}/ | less
			echo -n "==> Copy /var/abs/extra/$1/trunk contents here? "
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




case $1 in
	up) 	shift
		while getopts dteyc arg
			do	case ${arg} in
					d) docheckdeps="true" echo "checking for deps" ;;
					t) totesting="true" ;;
					e) toextra="true" ;;
					y) copy="true" ;;
					c) tocore="true" ;;
					*) echo "==> ERROR: Invalid argument ${arg}";;
				esac

			done

		shift $(($OPTIND - 1))

		if [[ $toextra == "true" ]] && [[ $totesting == "true" ]] || [[ $tocore == "true" ]]
			then echo "==> ERROR: Please specify a single repository to push to."
		fi


		for i in $*
			do	up $i
				shift
		done
		;;

	deps)	shift
		for i in $*
			do source $ORIGIN_DIR/$1/trunk/PKGBUILD
			   for dep in ${depends[@]} ${makedepends[@]}
			   	do echo $dep | tr '\n' ' '
			   done
			done
		;;

	check)	shift 2
		if [ -z $1 ]
			then	for i in $(ls $DEST_DIR)
					do check $i
				done
			else	check $*
		fi
		;;

	*)	[ -z $1 ] && printusage
		;;
esac

# vim: filetype=sh 
