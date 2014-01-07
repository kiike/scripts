#!/bin/bash
# A simple Pomodoro method timer

time_between_short_breaks=15m
short_break=5m
number_of_short_breaks_before_long_break=4
long_break=15m
bell_file="/usr/share/sounds/freedesktop/stereo/complete.oga"

let counter=0

function play_sound() {
	cmus-remote -u
	sleep .5
	mplayer -volume 0 -msglevel -1 $bell_file
	mplayer -msglevel -1 $bell_file
	sleep .5
	cmus-remote -u
}

notify() {
	echo -e "${1}\a"
	notify-send "Pomodoro.sh" "${1}"
}

while true; do
	notify "Do your work, for the love of God!"
	sleep $time_between_short_breaks
	let counter++

	play_sound

	if (($counter < $number_of_short_breaks_before_long_break)); then
		notify "You shall take a short break."
		sleep $short_break
	else
		notify "You shall take a long break."
		sleep $long_break
		let counter=0
	fi

	play_sound
done
