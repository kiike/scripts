#!/bin/bash
# xclip wrapper

case $1 in
	a) aria2c $(xclip -o);;
	co) xclip -sel clip -o;;
	m) mplayer $(xclip -o);;
	o) xclip -o;;
	x) xclip -o | xclip -sel clip;;
	*) echo "usage: $0 <a|co|m|o|x>";;
esac
