#!/bin/bash -eux

if [ ! -d "/data/domains/$DOMAIN/mysql/" ]; then
  mkdir -p /data/domains/$DOMAIN/mysql/
  echo MYSQL_PASS=`echo $RANDOM  ${date} | md5sum | base64 | cut -c-10` > /data/domains/$DOMAIN/mysql/.env
fi
