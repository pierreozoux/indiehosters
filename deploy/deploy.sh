#!/bin/sh
if [ $# -ge 2 ]; then
  SERVER=$1
  BACKUP_DESTINATION_1=$2
  BACKUP_DESTINATION_2=$3
else
  echo "Usage: sh ./deploy/deploy.sh server backup_destination_1 backup_destination_2 [branch [user]]]"
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
echo "Backups will be pushed to $BACKUP_DESTINATION_1 and $BACKUP_DESTINATION_2"
echo "IndieHosters repo branch is $BRANCH"
echo "Remote user is $USER"

scp ./deploy/onServer.sh $USER@$SERVER:

ssh $USER@$SERVER sudo mkdir -p /var/lib/coreos-install/
scp cloud-config $USER@$SERVER:/var/lib/coreos-install/user_data
ssh $USER@$SERVER sudo sh ./onServer.sh $BRANCH $SERVER

# overrides BACKUP_DESTINATION_1 from cloud-config
echo $BACKUP_DESTINATION_1 > ./deploy/tmp1.txt
scp ./deploy/tmp1.txt $USER@$SERVER:/data/BACKUP_DESTINATION_1
rm ./deploy/tmp1.txt

echo $BACKUP_DESTINATION_2 > ./deploy/tmp2.txt
scp ./deploy/tmp2.txt $USER@$SERVER:/data/BACKUP_DESTINATION_2
rm ./deploy/tmp2.txt
