FROM debian

# Chuẩn bị môi trường (chỉ chạy trong build, không phải runtime)
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y openssh-server sudo curl wget git htop nano

# Tạo user như file gốc tạo HOME
RUN useradd -m server && echo "server:123456" | chpasswd && usermod -aG sudo server

# Tạo folder SSH runtime (giống file gốc tạo folder trước khi chạy)
RUN mkdir -p /var/run/sshd

# Render không hỗ trợ cổng 22 nên đổi sang 10000
RUN echo "Port 10000" >> /etc/ssh/sshd_config

# Giữ kiểu EXPOSE như file gốc
EXPOSE 10000

# Giữ cấu trúc: COPY script ra ngoài như file gốc COPY/ENTRYPOINT
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
