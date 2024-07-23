#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run --name nginx -p 80:80 -v --hostname nginx-spark -d nginx

##Test
