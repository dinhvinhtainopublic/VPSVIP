FROM debian

RUN dpkg --add-architecture i386
RUN apt update

# Cài đúng gói như bản gốc + bổ sung thiếu để tránh lỗi x11/ssh
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    wine qemu-kvm xz-utils dbus-x11 curl firefox-esr \
    gnome-system-monitor mate-system-monitor git \
    xfce4 xfce4-terminal tightvncserver wget \
    openssh-server xrdp \
    fonts-wqy-zenhei  # thay cho *zenhei* bị lỗi wildcard

# Tạo noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && mv noVNC-1.2.0 /noVNC

# Tạo VNC cấu hình như bản gốc
RUN mkdir -p /root/.vnc && \
    echo 'admin123@a' | vncpasswd -f > /root/.vnc/passwd && \
    echo '/bin/env MOZ_FAKE_NO_SANDBOX=1 dbus-launch xfce4-session' > /root/.vnc/xstartup && \
    chmod 600 /root/.vnc/passwd && chmod 755 /root/.vnc/xstartup

# Khôi phục lại đúng luo.sh như bản gốc (VNC + noVNC)
RUN echo 'whoami' > /luo.sh
RUN echo 'cd' >> /luo.sh
RUN echo "vncserver :2000 -geometry 1360x768 -depth 16" >> /luo.sh
RUN echo 'cd /noVNC' >> /luo.sh
RUN echo './utils/launch.sh --vnc localhost:5900 --listen 8900' >> /luo.sh
RUN chmod +x /luo.sh

# Copy start.sh gốc để chạy XRDP (KHÔNG ghi đè luo.sh)
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose cổng đúng theo từng dịch vụ
EXPOSE 8900     # noVNC (web)
EXPOSE 3389     # XRDP (RDP)
EXPOSE 22       # SSH nếu muốn dùng

# ĐỂ NGUYÊN MẶC ĐỊNH NHƯ BẢN GỐC: chạy GUI VNC
CMD ["/luo.sh"]
