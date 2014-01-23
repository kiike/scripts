#!/usr/bin/env python3

from time import sleep
from subprocess import Popen, PIPE
fifo_in = '/tmp/in.fifo'

everything = ['desktops',
              '\\c', 'wm_title',
              '\\r', 'keyboard', 'date', '', '']


def build(everything, line):
    if line.startswith('WM'):
        line = line[2:]
        wm_info = line.split(':')
        wm_info.pop(0)
        wm_info.pop(-1)

        desktops = []
        for d in wm_info:
            if d.startswith('U') or d.startswith('O') or d.startswith('F'):
                desktops.append('\\f3' + d[1])
            elif d.startswith('u'):
                desktops.append('\\f1' + d[1])
            else:
                desktops.append('\\f2' + d[1])

        everything[0] = ' '.join(desktops)

    elif line.startswith('T'):
        everything[2] = line[1:]

    return everything


bar = Popen(['bar', '-p'],
            universal_newlines=True,
            stdin=PIPE)

with open(fifo_in) as f:
    while True:
        for line in f:
            line = line.strip()
            if len(line) > 0:
                everything = build(everything, line)
                print(everything, line)
                bar.stdin.write(' '.join(everything) + '\n')
            sleep(0.2)
