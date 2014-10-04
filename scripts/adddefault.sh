#!/bin/bash -eux

# Start wordpress service for new site (and create the user)
systemctl enable wordpress@default.service
systemctl start  wordpress@default.service

# Configure new site in HAproxy
IP=`docker inspect --format '{{.NetworkSettings.IPAddress}}' wordpress-default`

sed s/%HOSTNAME%/`hostname`/g /data/infrastructure/templates/haproxy-frontend.part | sed s/%IP%/$IP/g >> /data/server-wide/haproxy/frontends.part
sed s/%HOSTNAME%/`hostname`/g /data/infrastructure/templates/haproxy-backend.part | sed s/%IP%/$IP/g >> /data/server-wide/haproxy/backends.part
cat /data/server-wide/haproxy/haproxy-main.part /data/server-wide/haproxy/frontends.part /data/server-wide/haproxy/backends.part > /data/server-wide/haproxy/haproxy.cfg
systemctl reload haproxy.service
