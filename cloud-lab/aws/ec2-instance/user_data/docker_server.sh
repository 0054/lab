#!/usr/bin/env bash

yum install -y docker

#IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

systemctl enalbe docker
systemctl start docker
docker run -d --rm -p 80:80 --name nginx nginx
