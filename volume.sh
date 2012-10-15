#!/bin/sh

getvol() {
	amixer sget Master | \
		egrep dB | \
		cut -d ' ' -f 7 | \
		tr -d '[]'
}

setvol() {
	amixer -q sset Master $1
}

getmute() {
	if [ $(amixer sget Master | \
		egrep dB | cut -d ' ' -f 8 | \
		tr -d '[]') == "on" ]
	then
		echo "off"
	else
		echo "on"
	fi
}

mute() {
	amixer -q sset Master toggle
}

case $1 in
	s) setvol $2
	   notify-send -t 2000 -- 'Volume' "$(getvol)" ;;

	v) getvol
	   notify-send -t 2000 -- 'Volume' "Current volume: $(getvol)" ;;

	m) mute
	   notify-send -t 2000 -- 'Mute' "$(getmute)" ;;

	*) echo "	Usage:	volume.sh <v|m>"
	   echo "		v: get the current volume"
	   echo "		m: mute"
	   echo "		s: set the volume"
	   exit 1;;
esac
