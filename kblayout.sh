#!/bin/bash

CURRENT_LAYOUT=$(xkb-switch)

case $CURRENT_LAYOUT in
	es) setxkbmap us && notify-send -t 1000 'Keyboard layout' "$CURRENT_LAYOUT -> us";;
	us) setxkbmap es && notify-send -t 1000 'Keyboard layout' "$CURRENT_LAYOUT -> es";;
esac
