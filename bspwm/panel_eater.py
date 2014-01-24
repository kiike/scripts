#!/usr/bin/env python3

from time import sleep
from subprocess import Popen, PIPE
from sys import exit
import signal

fifo = '/tmp/panel.fifo'

everything = ['desktops',
              '\\c', 'wm_title',
              '\\r', 'keyboard', 'date']


def build(everything, line):
    """
    Parse the input line and put it into the 'everything' list in place

    [list], str -> str
    """

    if line.startswith('WM'):
        line = line[2:]
        wm_info = line.split(':')
        # Remove monitor label
        wm_info.pop(0)
        # Remove current tiling mode
        wm_info.pop(-1)

        desktops = []
        for d in wm_info:
            # Focused {urgent, occupied} desktops
            if d.startswith('U') or d.startswith('O') or d.startswith('F'):
                desktops.append('\\f1' + d[1] + '\\fr')
            # Unfocused urgent desktops
            elif d.startswith('u'):
                desktops.append('\\b8\\f3' + d[1] + '\\fr\\br')
            # Unfocused unoccupied desktops
            else:
                desktops.append(d[1])

        # Joined desktops lists -> everything's 1st field
        everything[0] = ' '.join(desktops)

    # Window title starts with T. Put it into the 3rd field
    elif line.startswith('T'):
        if len(line) > 69:
            everything[2] = line[1:69] + '...'
        else:
            everything[2] = line[1:]

    # Keyboard layout with K. Put it into the 5th field
    elif line.startswith('K'):
        everything[4] = line[1:]

    # Current date starts with D. Put it into the 6th field
    elif line.startswith('D'):
        everything[5] = line[1:]

    return everything


def die():
    """ Kill all the children and exit gracefully """
    print("Killing bar (" + str(bar.pid) + ")")
    bar.kill()
    exit()


def main():
    """ Start the main app loop """
    with open(fifo) as f:
        while True:
            for line in f:
                line_s = line.strip()
                if len(line_s) > 0:
                    output = build(everything, line_s)
                    bar.stdin.write(' '.join(output) + '\n')
                sleep(0.1)


# Start the program, trap SIGTERMs so as to kill the bar app.
if __name__ == '__main__':
    signal.signal(signal.SIGTERM, die)
    try:
        # Make the bar and get the input from the PIPE
        bar = Popen(['bar', '-p'], stdin=PIPE,
                    universal_newlines=True)

        # Start the program
        main()

    # Capture Ctrl+C
    except KeyboardInterrupt:
        die()
