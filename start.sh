#!/bin/bash

# Khởi động DBus (cần cho LXDE chạy ổn)
mkdir -p /var/run/dbus
dbus-daemon --system --fork

# Chuẩn bị thư mục X11
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start VNC server (màn hình desktop)
vncserver :1 -geometry 1280x720 -depth 16

# Start noVNC cho truy cập qua trình duyệt
cd /opt/novnc
./utils/launch.sh --vnc localhost:5901 --listen 8900
