#!/bin/sh

mount -t sysfs sysfs /var/build/sys
mount -t proc proc /var/build/proc
mount -o bind /var/cache/pacman/ /var/build/var/cache/pacman
mount -o bind /dev/ /var/build/dev

chroot /var/build su build

umount /var/build/dev
umount /var/build/sys
umount /var/build/proc
umount /var/build/var/cache/pacman

