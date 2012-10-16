#!/bin/sh
# Uncopyrighted. By Enric Morales. 2012

outputNowPlaying() {
	notify-send -t 2000 -- "Now playing:" "\"$(echo $TITLE)\"\nby $(echo $ARTIST)"
}

parseOutput() {
	grep " $1 " $TMP | cut -d " "  -f 3-
}

getStatus() {
	TMP=$(mktemp)
	cmus-remote -Q> $TMP
	ARTIST="$(parseOutput artist)"
	ALBUM="$(parseOutput album)"
	TITLE="$(parseOutput title)"
	rm $TMP
}

case $1 in
	togglePause)
		getStatus
		cmus-remote --pause
		outputNowPlaying
		;;
	next)
		getStatus
		cmus-remote --next
		outputNowPlaying
		;;
	prev)
		getStatus
		cmus-remote --prev
		outputNowPlaying
		;;
	stop)
		cmus-remote --stop
		;;
esac
