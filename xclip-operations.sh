#!/bin/bash
case $1 in
	m) mplayer $(xclip -o) ;;
	ma) mplayer -ao null $(xclip -o) ;;
	n) echo "$(xclip -o)" >> ~/.newsbeuter/urls ;;
	y) youtube-viewer "$(xclip -o)" -4;;
	w)
		cd ~/downloads
		wget $(xclip -o) ;;
	*) exit 1 ;;
esac
	
