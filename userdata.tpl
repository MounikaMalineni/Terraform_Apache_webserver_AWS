#!bin/bash

sudo yum update -y &&
sudo yum install -y curl
sudo yum install docker -y
sudo yum install git -y
sudo yum install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
aws s3 cp s3://webserver-conf/index.html /var/www/html/.