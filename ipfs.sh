#!/usr/bin/env bash

set -e

echo 'export IPFS_PATH=/data/ipfs' >>~/.bash_profile
source ~/.bash_profile

# ipfs daemon
wget https://dist.ipfs.io/go-ipfs/v0.4.15/go-ipfs_v0.4.15_linux-amd64.tar.gz
tar xvfz go-ipfs_v0.4.15_linux-amd64.tar.gz
rm go-ipfs_v0.4.15_linux-amd64.tar.gz
sudo mv go-ipfs/ipfs /usr/local/bin
rm -rf go-ipfs

# init ipfs
sudo mkdir -p $IPFS_PATH
sudo chown root:root $IPFS_PATH
ipfs init
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

# ipfs systemctl service
sudo bash -c 'cat >/lib/systemd/system/ipfs.service <<EOL
[Unit]
Description=ipfs daemon
[Service]
ExecStart=/usr/local/bin/ipfs daemon --enable-gc --enable-pubsub-experiment
Restart=always
User=root
Group=root
Environment="IPFS_PATH=/data/ipfs"
[Install]
WantedBy=multi-user.target
EOL'

# enable the new services
sudo systemctl daemon-reload
sudo systemctl enable ipfs.service

sudo systemctl start ipfs
