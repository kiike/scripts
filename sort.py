#!/usr/bin/env python2
import os, sys, locale, time
locale.setlocale(locale.LC_ALL, '')
os.chdir(sys.argv[1])
dir = sorted(os.listdir('.'), locale.strcoll)
t = time.time() - 2*len(dir)
for file in dir:
    t += 2
    os.utime(file, (t, t))
    print('%s has time %s' % (file, time.ctime(t)))
