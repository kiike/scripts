#!/usr/bin/env python

import socket
import sys

conn = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
conn.connect('/var/run/user/1000/uim/socket/uim-helper')

while True:
    msg, addr = conn.recvfrom(2048)
    msg = msg.decode('UTF-8').replace('\t', ' ')
    im = [line for line in msg.split('\n') if line.startswith('branch')]
    if len(im) > 0:
        name = im[0].split()[2]
        mode = im[1].split()[2]
        output = 'UIM{} {}'.format(name, mode)
        print(output)
        sys.stdout.flush()
