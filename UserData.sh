#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker
sudo docker pull sebtec1212/myimage
docker run -d --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock v2tec/watchtower -i 30
sudo docker run -d -p 80:80 sebtec1212/myimage

sudo yum install -y amazon-cloudwatch-agent
sudo cat >> /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOF
{
    "agent": {
            "metrics_collection_interval": 60,
            "run_as_user": "root"
    },
    "metrics": {
            "metrics_collected": {
                    "disk": {
                            "measurement": [
                                    "used_percent"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "/"
                            ]
                    },
                    "mem": {
                            "measurement": [
                                    "mem_used_percent"
                            ],
                            "metrics_collection_interval": 60
                    }
            }
    }
}
EOF
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

