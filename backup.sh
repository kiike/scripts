#!/bin/bash

rsync	-aP \
	--delete \
	--exclude-from=.rsync.exclude \
	${HOME}/ /media/Shadaloo/Backup/
