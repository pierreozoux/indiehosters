  apt-get update
  apt-get install systemd-sysv ruby-dev gcc make
  shutdown -r now

  gem install fpm
  curl -L https://raw.githubusercontent.com/solarkennedy/etcd-packages/master/Makefile  > Makefile
  make deb
  dpkg -i etcd_0.4.3_amd64.deb
  cp /data/indiehosters/deploy/etcd.conf /etc/etcd/
