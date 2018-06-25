#!/usr/bin/env bash

set -e

# install nginx
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install ./epel-release-latest-7.noarch.rpm -y
sudo yum install nginx -y
rm epel-release-latest-7.noarch.rpm
setenforce 0

# grab config files
wget https://raw.githubusercontent.com/hautph/ipfs/master/ipfs-gateway-nginx.conf
sudo mv ipfs-gateway-nginx.conf /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/hautph/ipfs/master/nginx-gzip.conf
sudo mv nginx-gzip.conf /etc/nginx/conf.d/gzip.conf

# setup cache dir
sudo mkdir -p /data/nginx/cache

# fix nginx bug (https://bugs.launchpad.net/ubuntu/+source/nginx/+bug/1581864/comments/2)
sudo mkdir /etc/systemd/system/nginx.service.d
sudo bash -c 'printf "[Service]\nExecStartPost=/bin/sleep 0.1\nRestart=always\n" > /etc/systemd/system/nginx.service.d/override.conf'
sudo systemctl daemon-reload

# start
sudo systemctl start nginx
