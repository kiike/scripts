#!/usr/bin/env python3
# A script that will start and manage the processes
# that feed the dzen2 panel

import signal
import subprocess
import os
import sys

fifo = '/tmp/panel.fifo'

apps = {'clock': 'clock D',
        'keyboard': 'kbdlayout get',
        'mail': 'maildir_check M',
        'bspwm_status': 'bspc control --subscribe',
        'win_title': 'xtitle -sf T%s'
        }

enabled_apps = ['bspwm_status',
                'clock',
                'win_title']

active_apps = []


def start():
    """ Start all the processes in the "enabled_apps" list. """
    if not os.path.exists(fifo):
        os.mkfifo(fifo)

    with open(fifo, mode='w') as f:
        for app in enabled_apps:
            cmd = apps[app].split()
            print(cmd)

            child = subprocess.Popen(cmd, stdout=f,
                                     universal_newlines=True,
                                     stdin=None)
            print('Started', app, '(' + str(child.pid) + ')')
            active_apps.append(child)

        subprocess.call(apps['keyboard'].split(), stdout=f)
        for app in active_apps:
            app.wait()


def check():
    """ Check if another instance is running. """
    pgrep = subprocess.call(["pgrep", "panel_feeder"])
    if pgrep == 1:
        return True


def die():
    for app in active_apps:
        print('Killing', app)
        app.kill()

    print('Cleaning up...')
    os.remove(fifo)
    print('Bye!')
    sys.exit()

if __name__ == '__main__':
    if check():
        signal.signal(signal.SIGTERM, die)
        try:
            start()
        except KeyboardInterrupt:
            die()
    else:
        sys.exit('ERROR: Another instance of the panel is already running.')
