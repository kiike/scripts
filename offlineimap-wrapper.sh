#!/bin/bash
#
# An OfflineIMAP wrapper. It will just execute OfflineIMAP
# every X minutes. Default is 30 minutes.
#
# Released under the public domain by Enric Morales, 2011.


if [ -z "$1" ]
	then offlineimap; sleep 30m
	else offlineimap; sleep "$1"m
fi
