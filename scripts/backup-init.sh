#!/bin/bash -eux

BACKUPDEST=`etcdctl get /backup/destination/prefix`/$DOMAIN.git

echo "First, trying to clone latest master from $BACKUPDEST"
if [ ! -d /data/domains/$DOMAIN ]; then
  git clone $BACKUPDEST /data/domains/$DOMAIN
  cd /data/domains/$DOMAIN
  git config --local user.email "backups@`hostname`"
  git config --local user.name "`hostname` hourly backups"
  git config --local push.default simple
fi
