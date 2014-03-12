# A module for panel.py that outputs the battery level
# into the queue every minute.
from time import sleep


def get_battery_charge(path):
    with open(path + 'energy_full') as f:
        capacity = int(f.read())
        with open(path + 'energy_now') as f:
            current_charge = int(f.read())

    charge = int(current_charge / capacity * 100)
    return str(charge)


def main(queue, prefix='B'):
    BATTERY_PATH = '/sys/class/power_supply/BAT0/'
    while True:
        charge = get_battery_charge(BATTERY_PATH)
        output = '{}{}'.format(prefix, charge)
        queue.put(output)
        sleep(60)
