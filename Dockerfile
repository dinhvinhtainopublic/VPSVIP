FROM debian:latest

## Kiến trúc & update
RUN dpkg --add-architecture i386
RUN apt update

## Cài GUI nhẹ + VNC + Firefox nhẹ
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    lxde lxtask openbox \
    firefox-esr --no-install-recommends \
    tightvncserver novnc websockify \
    dbus-x11 xz-utils curl git wget

## Tối ưu RAM cho Firefox (profile nhẹ)
RUN mkdir -p /etc/firefox
RUN echo "MOZ_DISABLE_GMP_SANDBOX=1" >> /etc/firefox/firefox.conf
RUN echo "user_pref(\"browser.sessionstore.max_tabs_undo\", 2);" >> ~/.mozilla/firefox/prefs.js
RUN echo "user_pref(\"browser.cache.disk.capacity\", 20480);" >> ~/.mozilla/firefox/prefs.js

## Cài noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz && mv noVNC-1.2.0 /opt/novnc

## Setup VNC
RUN mkdir -p $HOME/.vnc
RUN echo '12345678' | vncpasswd -f > $HOME/.vnc/passwd
RUN echo '#!/bin/sh' > $HOME/.vnc/xstartup
RUN echo 'lxsession &' >> $HOME/.vnc/xstartup
RUN chmod 600 $HOME/.vnc/passwd
RUN chmod +x $HOME/.vnc/xstartup

## Script chạy desktop
RUN echo '#!/bin/bash' > /start.sh
RUN echo "vncserver :1 -geometry 1280x720 -depth 16" >> /start.sh
RUN echo "cd /opt/novnc && ./utils/launch.sh --vnc localhost:5901 --listen 8900" >> /start.sh
RUN chmod +x /start.sh

EXPOSE 8900
CMD ["/start.sh"]
