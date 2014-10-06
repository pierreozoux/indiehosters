sudo docker stop haproxy
sudo docker rm haproxy
sudo docker run -d --name haproxy -p 80:80 -p 443:443 -v /data/server-wide/haproxy:/haproxy-override dockerfile/haproxy
sudo docker ps -a | grep haproxy
sudo docker logs haproxy
