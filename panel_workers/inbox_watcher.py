# Monitors the number of new messages in PATH and outputs to the queue
from time import sleep
from os import walk, path, getenv

PATH = path.join(getenv('HOME'), 'mail', 'inbox', 'new')
PREFIX = 'M'


def main(queue):
    while True:
        # Let's walk the first argument
        for root, dirs, files in walk(PATH):
            # Print prefix together with the number of
            # files we found
            output = '{}{}'.format(PREFIX, str(len(files)))
            queue.put(output)

        sleep(60)
