#!/bin/bash

# Tạo thư mục runtime giống bản gốc tạo folder trước khi chạy lệnh
mkdir -p /var/run/sshd

# Chạy SSH đúng port, không có apt, không cài gì thêm
exec /usr/sbin/sshd -D -p 10000
