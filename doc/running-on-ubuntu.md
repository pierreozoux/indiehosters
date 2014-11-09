To run an IndieHosters on ubuntu 14.10 (earlier versions will not work), run something like:

  apt-get update
  apt-get install systemd-sysv ruby-dev gcc make
  shutdown -r now

  gem install fpm
  curl -L https://raw.githubusercontent.com/solarkennedy/etcd-packages/master/Makefile  > Makefile
  make deb
  dpkg -i etcd_0.4.3_amd64.deb
  cp /data/indiehosters/deploy/etcd.conf /etc/etcd/
  etcd &
  systemctl list-units
  etcdctl ls

Right now this still give the following problem:

````
root@ku:~# etcd &
[1] 3584
root@ku:~# [etcd] Nov  5 23:59:45.781 INFO      | Discovery via https://discovery.etcd.io using prefix /.
[etcd] Nov  5 23:59:46.019 WARNING   | Discovery encountered an error: invalid character 'p' after top-level value
[etcd] Nov  5 23:59:46.019 WARNING   | etcd failed to connect discovery service[https://discovery.etcd.io/]: invalid character 'p' after top-level value
[etcd] Nov  5 23:59:46.019 CRITICAL  | etcd, the new instance, must register itself to discovery service as required

[1]+  Exit 1                  etcd
root@ku:~# 
````

But we're working on fixing that somehow.

