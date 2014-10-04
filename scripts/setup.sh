#!/bin/bash -eux

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull tutum/mysql
docker pull tutum/wordpress-stackable

# Start wordpress service for default site (and create the user)
systemctl enable wordpress@default.service
systemctl start  wordpress@default.service

# Configure and start HAproxy
docker pull dockerfile/haproxy
mkdir -p /data/server-wide/haproxy
IP=`docker inspect --format {{.NetworkSettings.IPAddress}} wordpress-default`
HOSTNAME=`hostname`
sed s/%HOSTNAME%/$HOSTNAME/ /data/infrastructure/templates/haproxy.cfg | sed s/%IP%/$IP/ > /data/server-wide/haproxy/haproxy.cfg
systemctl enable haproxy.service
systemctl start  haproxy.service
