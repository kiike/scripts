#!/bin/bash
case $1 in
	m) mplayer $(xclip -o) ;;
	ma) mplayer -ao null $(xclip -o) ;;
	n) echo "$(xclip -o)" >> ~/.config/newsbeuter/urls ;;
	p) plowdown -v 3 "$(xclip -o)";;
	y) youtube-viewer "$(xclip -o)" -4;;
	d) 	cd ~/downloads
		wget $(xclip -o) ;;
	w) wget $(xclip -o) ;;
	*) exit 1 ;;
esac
	
