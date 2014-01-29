#!/bin/zsh
case $1; in
	255|256)
		for code in {000..255}; do
			print -P -- "%F{$code}$code $code $code}Test%f"
		done
		;;
	16|*)
		for code in {000..15}; do
			print -P -- "%F{$code}$code $code $code%f"
		done
		;;
esac

