# A module for panel.py that outputs the current date
# every minute into the `queue`

from time import strftime, sleep, localtime


def main(queue, prefix='D'):
    DATE_FORMAT = prefix + '%a %d %b, %H:%M'
    while True:
        out = strftime(DATE_FORMAT)
        queue.put(out)
        time = localtime()
        seconds_to_sleep = 60 - time.tm_sec
        sleep(seconds_to_sleep)
