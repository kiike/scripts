# Listens for messages in a fifo and outputs them to the queue

from os import mkfifo, path
import select

PATH = '/tmp/panel.fifo'
READ_ONLY = select.POLLIN | select.POLLPRI | select.POLLHUP | select.POLLERR

if not path.exists(PATH):
    mkfifo(PATH)


def main(queue):
    with open(PATH) as fifo:
        poller = select.poll()
        poller.register(fifo, READ_ONLY)
        while True:
            poller.poll()
            line = fifo.readline()
            line = line.strip()
            if len(line) > 0:
                queue.put(line)
