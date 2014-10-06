rm /etc/systemd/system/multi-user.target.wants/*
while read p; do
  systemctl enable $p.service
  systemctl start $p.service
done </data/soll.txt
