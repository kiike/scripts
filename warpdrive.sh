#!/usr/bin/sh
# Engage Warp Drive

# Requires package 'sox'
# http://www.reddit.com/r/linux/comments/n8a2k/commandline_star_trek_engine_noise_comment_from/

case $1 in
	original)
		# odokemono
		# http://www.reddit.com/r/scifi/comments/n7q5x/want_to_pretend_you_are_aboard_the_enterprise_for/c36xkjx
		# original
		play -n -c2 synth whitenoise band -n 100 20 band -n 50 20 gain +20 fade h 1 864000 1
		;;

	stereo)
		# noname-_-
		# http://www.reddit.com/r/scifi/comments/n7q5x/want_to_pretend_you_are_aboard_the_enterprise_for/c373gpa
		# stereo
		play -c2 -n synth whitenoise band -n 100 24 band -n 300 100 gain +20
		;;

	tng)
		# braclayrab
		# http://www.reddit.com/r/scifi/comments/n7q5x/want_to_pretend_you_are_aboard_the_enterprise_for/c372pyy
		# TNG
		play -n -c1 synth whitenoise band 100 20 compand .3,.8 -1,-10 gain +20
		;;

	tng-engine)
		# https://www.youtube.com/watch?list=UUF6R1ZDskjCeBMomUGCtxXw&v=sCSaqkyQVio
		play -c 2 -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +10
		;;

	2waymix)
		# http://www.reddit.com/r/scifi/comments/n7q5x/want_to_pretend_you_are_aboard_the_enterprise_for/c3d9dle
		play -c2 -n synth whitenoise band -n 100 24 band -n 300 100 gain +4 \
			synth whitenoise lowpass -1 100 lowpass -1 100 lowpass -1 100 gain +2
		;;

	3waymix)
		# http://www.reddit.com/r/scifi/comments/n7q5x/want_to_pretend_you_are_aboard_the_enterprise_for/c375vm0
		play -n -c2 synth whitenoise band -n 100 20 band -n 50 20 gain +20 fade h 1 864000 1 \
			synth whitenoise lowpass -1 100 lowpass -1 50 gain +7 \
			synth whitenoise band -n 3900 50 gain -30
		;;

	*)
		echo "Usage: $0 original|stereo|tng|tng-engine|2waymix|3waymix"
		;;
esac
