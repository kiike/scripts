from threading import Thread
from time import sleep, strftime, localtime
from os import path
from queue import Queue
from collections import OrderedDict
from subprocess import Popen, PIPE
from shlex import split


class Module(Thread):
    def __init__(self, queue, **kwargs):
        Thread.__init__(self, group=None, name=kwargs['name'])
        self.name = kwargs['name']
        self.queue = queue
        self.kwargs = kwargs


class App(Module):
    def run(self):
        command = split(self.kwargs['command'])
        p = Popen(command, stdin=None, stdout=PIPE,
                  universal_newlines=True)
        while True:
            item = p.stdout.readline()
            if item:
                self.queue.put((self.name, item.strip()))
            else:
                sleep(0.1)


class Battery(Module):
    def get(self, item):
        battery_id = self.kwargs['battery_id']
        basedir = '/sys/class/power_supply/'
        self.battery_path = path.join(basedir, battery_id)

        with open(path.join(self.battery_path, item)) as f:
            return int(f.read())

    def run(self):
        print
        while True:
            charge = self.get('energy_now') / self.get('energy_full') * 100
            output = (self.name, '{}{}'.format(int(charge), '%'))
            self.queue.put(output)
            sleep(60)


class Clock(Module):
    def run(self):
        template = '%a %d %b, %H:%M:%S'
        while True:
            output = (self.name, strftime(template))
            self.queue.put(output)
            time = localtime()
            seconds_to_sleep = 60 - time.tm_sec
            sleep(seconds_to_sleep)


if __name__ == '__main__':
    queue = Queue()
    battery = Battery(queue, name='battery', battery_id='BAT0')
    clock = Clock(queue, name='clock')
    desktop_list = App(queue, command='bspc control --subscribe',
                       name='desktop_list')
    battery.start()
    clock.start()
    desktop_list.start()

    layout = ('desktop_list', 'separator', 'center', 'win_title',
              'right', 'battery', 'clock')
    statusline = OrderedDict()
    for key in layout:
        if key == 'separator':
            value = ' '
        elif key == 'right':
            value = '%{r}'
        elif key == 'center':
            value = '%{c}'
        else:
            value = ''

        statusline[key] = value

    print(statusline)

    while True:
        item = queue.get()
        print(item)
        item_id, item_value = item[0], item[1]
        statusline[item_id] = item_value
        print(''.join(statusline.values()))
