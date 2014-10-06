#!/bin/bash -eux
cp /data/infrastructure/templates/haproxy-main.part /data/server-wide/haproxy/
cat /data/server-wide/haproxy/haproxy-main.part /data/server-wide/haproxy/frontends.part /data/server-wide/haproxy/backends.part > /data/server-wide/haproxy/haproxy.cfg
systemctl reload haproxy.service
