#!/bin/bash -eux

mkdir -p /data/server-wide/haproxy/certs
touch /data/server-wide/haproxy/certs/list.txt
touch /data/server-wide/haproxy/frontends.part
touch /data/server-wide/haproxy/certs.part
touch /data/server-wide/haproxy/backends.part

cp /data/infrastructure/templates/haproxy-*.part /data/server-wide/haproxy/

cat /data/server-wide/haproxy/haproxy-1.part /data/server-wide/haproxy/certs.part /data/server-wide/haproxy/haproxy-2.part /data/server-wide/haproxy/frontends.part /data/server-wide/haproxy/backends.part > /data/server-wide/haproxy/haproxy.cfg

systemctl reload haproxy.service
