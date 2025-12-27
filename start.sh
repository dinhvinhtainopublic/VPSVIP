#!/bin/bash
mkdir -p /var/run/dbus
dbus-daemon --system --fork

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Chạy LXDE nếu dùng XRDP
startlxde &
/usr/sbin/xrdp --nodaemon
