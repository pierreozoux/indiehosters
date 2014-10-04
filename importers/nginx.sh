#!/bin/bash

if [ ! -d "/data/per-user/$USER/nginx/data" ]; then
  mkdir -p /data/per-user/$USER/nginx
  cd /data/per-user/$USER/nginx
  echo Hello $USER > index.html
  touch /data/per-user/$USER/nginx/.env
fi
