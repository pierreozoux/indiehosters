#!/bin/bash -eux

# Start service for new site (and create the user)
systemctl enable $2@$1.service
systemctl start  $2@$1.service

sleep 10

# Configure new site in HAproxy
IP=`docker inspect --format '{{.NetworkSettings.IPAddress}}' $2-$1`

echo IP address of new container \'$2-$1\' is \'$IP\'

if [ -f /data/server-wide/haproxy/certs/%HOSTNAME%/combined.pem ] then
sed s/%HOSTNAME%/$1/g /data/infrastructure/templates/haproxy-cert.part >> /data/server-wide/haproxy/certs.part
else
echo WARNING: TLS cert /data/server-wide/haproxy/certs/%HOSTNAME%/combined.pem not found! Not enabling SNI for this domain.
fi

sed s/%HOSTNAME%/$1/g /data/infrastructure/templates/haproxy-frontend.part >> /data/server-wide/haproxy/frontends.part

sed s/%HOSTNAME%/$1/g /data/infrastructure/templates/haproxy-backend.part | sed s/%IP%/$IP/g >> /data/server-wide/haproxy/backends.part

cat /data/server-wide/haproxy/haproxy-1.part /data/server-wide/haproxy/certs.part /data/server-wide/haproxy/haproxy-2.part /data/server-wide/haproxy/frontends.part /data/server-wide/haproxy/backends.part > /data/server-wide/haproxy/haproxy.cfg
systemctl reload haproxy.service
