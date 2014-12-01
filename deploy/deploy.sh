#!/bin/sh
if [ $# -ge 3 ]; then
  SERVER=$1
  BACKUP_DEST=$2
  BACKUP_DEST_2=$3
else
  echo "Usage: sh ./deploy/deploy.sh server backup_dest backup_dest_2 [branch [user]]]"
  exit 1
fi
if [ $# -ge 4 ]; then
  BRANCH=$4
else
  BRANCH="master"
fi
if [ $# -ge 5 ]; then
  USER=$5
else
  USER="core"
fi

echo "Server to deploy is $SERVER"
echo "Backups will go to $BACKUP_DEST and $BACKUP_DEST_2"
echo "IndieHosters repo branch is $BRANCH"
echo "Remote user is $USER"

scp ./deploy/onServer.sh $USER@$SERVER:

ssh $USER@$SERVER sudo mkdir -p /var/lib/coreos-install/
scp cloud-config-production $USER@$SERVER:/var/lib/coreos-install/user_data
ssh $USER@$SERVER sudo sh ./onServer.sh $BRANCH $SERVER

echo $BACKUP_DEST > ./deploy/tmp1.txt
echo $BACKUP_DEST_2 > ./deploy/tmp2.txt
scp ./deploy/tmp1.txt $USER@$SERVER:/data/BACKUP_DESTINATION
scp ./deploy/tmp2.txt $USER@$SERVER:/data/BACKUP_DESTINATION_2
rm ./deploy/tmp*
