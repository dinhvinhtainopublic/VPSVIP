FROM debian

RUN dpkg --add-architecture i386
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    wine qemu-kvm xz-utils dbus-x11 curl firefox-esr \
    gnome-system-monitor mate-system-monitor git \
    xfce4 xfce4-terminal tightvncserver wget

# noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz
RUN mv noVNC-1.2.0 /noVNC

# VNC setup
RUN mkdir -p $HOME/.vnc
RUN echo 'admin123@a' | vncpasswd -f > $HOME/.vnc/passwd
RUN echo '/bin/env MOZ_FAKE_NO_SANDBOX=1 dbus-launch xfce4-session' > $HOME/.vnc/xstartup
RUN chmod 600 $HOME/.vnc/passwd
RUN chmod 755 $HOME/.vnc/xstartup

# luo.sh giữ nguyên chức năng gốc
RUN echo 'whoami' > /luo.sh
RUN echo 'cd' >> /luo.sh
RUN echo "vncserver :2000 -geometry 1360x768" >> /luo.sh
RUN echo 'cd /noVNC' >> /luo.sh
RUN echo './utils/launch.sh --vnc localhost:7900 --listen 8900' >> /luo.sh
RUN chmod 755 /luo.sh

# giữ start.sh riêng, không đè, không chạm cấu trúc
COPY start.sh /start.sh
RUN chmod +x /start.sh

# không đặt comment sau EXPOSE nữa
EXPOSE 8900
EXPOSE 3389
EXPOSE 22

CMD ["/luo.sh"]
