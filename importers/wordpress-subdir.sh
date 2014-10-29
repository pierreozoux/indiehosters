#!/bin/bash

if [ ! -d "/data/per-user/$USER/wordpress-subdir/data" ]; then
  cd /data/per-user/$USER/
  tar xvzf /data/indiehosters/blueprints/wordpress.tgz
  cat /data/per-user/$USER/mysql/.env | sed s/MYSQL_PASS/DB_PASS/ > /data/per-user/$USER/wordpress-subdir/.env
fi

if [ ! -e "/data/per-user/$USER/wordpress-subdir/data/www-content/index.html" ]; then
  if [ -e "/data/per-user/$USER/wordpress-subdir/data/git-url.txt" ]; then
    git clone `cat /data/per-user/$USER/wordpress-subdir/data/git-url.txt` /data/per-user/$USER/wordpress-subdir/data/www-content
  else
    mkdir -p /data/per-user/$USER/wordpress-subdir/data/www-content
    echo Hello $USER > /data/per-user/$USER/wordpress-subdir/data/www-content/index.html
  fi
fi
