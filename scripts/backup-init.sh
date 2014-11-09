#!/bin/bash -eux

BACKUP_DESTINATION_1=`cat /data/BACKUP_DESTINATION_1`
BACKUP_DESTINATION_2=`cat /data/BACKUP_DESTINATION_2`

echo "Intitializing backups to $BACKUP_DESTINATION_1 and $BACKUP_DESTINATION_2"
if [ ! -d /data/domains/$DOMAIN/.git ]; then
  if [ `ssh $BACKUP_DESTINATION_1 "test -d $DOMAIN"; echo $?` -eq 0 ]; then # git repo exists on backup server 1
    echo "Backup destination 1 exists and is reachable. Importing user data from there..."
    git clone $BACKUP_DESTINATION_1:$DOMAIN /data/domains/$DOMAIN
  else
    ssh $BACKUP_DESTINATION_1 " \
      mkdir -p $DOMAIN; \
      cd $DOMAIN; \
      git init --bare;"
    if [ ! -d /data/domains/$DOMAIN ]; then
      mkdir /data/domains/$DOMAIN
    fi
    cd /data/domains/$DOMAIN
    git init
    git remote add origin $BACKUP_DESTINATION_1:$DOMAIN
  fi

  if [ `ssh $BACKUP_DESTINATION_2 "test -d $DOMAIN"; echo $?` -eq 0 ]; then # git repo exists on backup server 2
    echo "Backup destination 2 exists and is reachable."
  else
    ssh $BACKUP_DESTINATION_2 " \
      mkdir -p $DOMAIN; \
      cd $DOMAIN; \
      git init --bare;"
  fi

  cd /data/domains/$DOMAIN
  git remote add secondary $BACKUP_DESTINATION_2:$DOMAIN

  git config --local user.email "backups@`hostname`"
  git config --local user.name "`hostname` hourly backups"
fi
