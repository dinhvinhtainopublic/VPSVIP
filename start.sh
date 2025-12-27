#!/bin/bash
mkdir -p /var/run/dbus
dbus-daemon --system --fork

service ssh start

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

/usr/sbin/xrdp --nodaemon
