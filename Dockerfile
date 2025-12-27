FROM debian

RUN apt update && apt install -y openssh-server sudo curl wget git htop nano

# Tạo user
RUN useradd -m server && echo "server:123456" | chpasswd && usermod -aG sudo server

# Chuẩn bị SSH
RUN mkdir /var/run/sshd

# 🔥 Quan trọng: đổi SSH sang port 10000 (Render mới nhận)
RUN echo "Port 10000" >> /etc/ssh/sshd_config

# 🔥 Expose port cho Render
EXPOSE 10000

# Chạy sshd trên port 10000
CMD ["/usr/sbin/sshd", "-D"]
