#!/bin/bash
# xclip wrapper

case $1 in
	a)
		aria2c "$(xclip -o)"
		;;

	b)
		echo -e "\n$(date)\n$(xclip -o)\n" >> ${HOME}/documents/basket.txt
		;;

	c)
		curl "$(xclip -o)" | less
		;;

	cc)
		echo "" | xclip
		;;

	m)
		shift
		mpv $* $(xclip -o)
		;;

	o)
		xclip -o
		;;

	y)
		youtube-viewer --video-player=mpv $(xclip -o)
		;;

	*)
		echo "usage: $0 <a|co|m|o|x>"
		;;
esac
