#!/usr/bin/env python3
# A script that will start and manage the processes
# that feed the bar-aint-recursive panel maker (./panel_parser)


import subprocess
from queue import Queue
from threading import Thread
from time import sleep

from panel_workers import clock, parser, battery, fifo_listener
from panel_workers import inbox_watcher, one_shot_applets

apps = {'keyboard': 'kbdlayout get',
        'bspwm_status': 'bspc control --subscribe',
        'win_title': 'xtitle -sf T%s'
        }

enabled_apps = ['bspwm_status',
                'win_title'
                ]

enabled_modules = [battery.main,
                   clock.main,
                   parser.main,
                   inbox_watcher.main,
                   one_shot_applets.main,
                   fifo_listener.main
                   ]

active_apps, active_modules = [], []


def enqueue_stdout(out, queue):
    while True:
        data = out.readline().strip()
        if not data:
            sleep(0.1)
        else:
            queue.put(data)


def main():
    fifo = Queue()
    for module in enabled_modules:
        thread = Thread(target=module, args=(fifo,), name=module)
        thread.start()
        active_modules.append(thread)

    for app in enabled_apps:
        app = subprocess.Popen(apps[app].split(),
                               shell=False,
                               stdin=None,
                               universal_newlines=True,
                               stdout=subprocess.PIPE)
        thread = Thread(target=enqueue_stdout, args=(app.stdout, fifo))
        thread.start()
        active_apps.append(thread)


def die(*args):
    for app in active_apps:
        app.kill()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        die()
