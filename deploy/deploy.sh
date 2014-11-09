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

rm -rf ./deploy/data
mkdir -p ./deploy/data
echo $BACKUP_DESTINATION_1 > ./deploy/data/BACKUP_DESTINATION_1
echo $BACKUP_DESTINATION_2 > ./deploy/data/BACKUP_DESTINATION_2

printf "#!/bin/bash\nmkdir -p /data\n\
git clone https://github.com/indiehosters/indiehosters.git /data/indiehosters\n\
cd /data/indiehosters && git checkout $BRANCH && git pull\n\
sh scripts/setup.sh $SERVER\n" > ./deploy/data/onServer.sh

scp -r ./deploy/data $USER@$SERVER:/
rm -rf ./deploy/data

ssh $USER@$SERVER sudo sh /data/onServer.sh
