#!/bin/bash

# Khởi tạo thư mục SSH runtime
mkdir -p /var/run/sshd

# Chạy SSH trên port 10000 (đã set trong Dockerfile)
exec /usr/sbin/sshd -D -p 10000
