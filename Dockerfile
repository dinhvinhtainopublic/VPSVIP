FROM debian

RUN dpkg --add-architecture i386
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    wine qemu-kvm xz-utils dbus-x11 curl firefox-esr git \
    lxde-core lxde-icon-theme lxtask lxterminal \
    tightvncserver wget novnc websockify

# noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz

# VNC Config
RUN mkdir -p $HOME/.vnc && \
    echo 'admin123@a' | vncpasswd -f > $HOME/.vnc/passwd && \
    echo 'LXDE' > $HOME/.vnc/desktop && \
    echo '#!/bin/sh\nstartlxde &' > $HOME/.vnc/xstartup && \
    chmod 600 $HOME/.vnc/passwd && \
    chmod +x $HOME/.vnc/xstartup

# Start Script
RUN echo '#!/bin/bash' > /start.sh && \
    echo "vncserver :2000 -geometry 1360x768 -depth 24" >> /start.sh && \
    echo "cd /noVNC-1.2.0" >> /start.sh && \
    echo "./utils/launch.sh --vnc localhost:5900 --listen 8900" >> /start.sh && \
    chmod +x /start.sh

EXPOSE 8900
CMD ["/start.sh"]
