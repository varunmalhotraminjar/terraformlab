#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo docker info
sudo docker version
