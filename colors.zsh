#!/bin/zsh
case $(tput colors); in
	256)	for code in {000..255}; do
			print -P -- "$code: %F{$code}Test%f"
		done
		;;
	*)	for code in {000..15}; do
			print -P -- "$code: %F{$code}Test%f"
		done
		;;
esac

