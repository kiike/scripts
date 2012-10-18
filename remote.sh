#!/bin/sh

formatTime() {
	local S=${1}
	((m=S%3600/60))
	((s=S%60))
	[ ${#s} == 1 ] && s=0$s	# Add a leading zero if needed

	echo $m:$s
}

outputNowPlaying() {
	if [ -n "$TITLE" ] && [ -n "DURATION" ]
	then
		notify-send -t 1000 -- "Now playing" "\"$TITLE\" ($DURATION)\nby $ARTIST"
	else
		notify-send -t 1000 -- "Nothing playing"
	fi
}

parseOutput() {
	grep -w $1 $TMP | cut -d " "  -f 3-
}

getStatus() {
	TMP=$(mktemp)
	cmus-remote -Q> $TMP
	ARTIST="$(parseOutput artist)"
	ALBUM="$(parseOutput album)"
	TITLE="$(parseOutput title)"
	DURATION="$(formatTime $(grep -w duration $TMP | cut -d " " -f 2))"
	rm $TMP
}

case $1 in
	togglePause)
		cmus-remote --pause
		getStatus
		outputNowPlaying
		;;
	next)
		cmus-remote --next
		getStatus
		outputNowPlaying
		;;
	prev)
		cmus-remote --prev
		getStatus
		outputNowPlaying
		;;
	stop)
		cmus-remote --stop
		;;
esac
