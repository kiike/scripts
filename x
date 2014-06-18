#!/bin/bash
# xclip wrapper

case $1 in
	a) aria2c $(xclip -o);;
	co) xclip -sel clip -o;;
	cc) echo "" | xclip ;;
	m) mpv $(xclip -o);;
	o) xclip -o;;
	x) xclip -o | xclip -sel clip;;
	y) youtube-viewer --video-player=mpv $(xclip -o);;
	*) echo "usage: $0 <a|co|m|o|x>";;
esac
