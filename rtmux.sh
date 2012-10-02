#!/bin/sh

tmux new-session \
	-n rtorrent \
	-s rtorrent  \
	'cd /media/Shadaloo/Downloads && rtorrent'
