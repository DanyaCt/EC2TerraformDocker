#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo docker pull sebtec1212/myimage
docker run -d --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock v2tec/watchtower -i 30
sudo docker run -d -p 80:80 sebtec1212/myimage
