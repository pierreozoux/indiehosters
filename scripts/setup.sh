#!/bin/bash -eux

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull tutum/mysql
docker pull tutum/wordpress-stackable

# Configure and start HAproxy
docker pull dockerfile/haproxy
mkdir -p /data/server-wide/haproxy
cp /data/infrastructure/templates/haproxy-main.part /data/server-wide/haproxy/haproxy-main.part
systemctl enable haproxy.service
systemctl start  haproxy.service
