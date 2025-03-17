#!/usr/bin/env bash

USR="vagrant"
VERSION_COMPOSE=`curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tarball_url | cut -d/ -f8 | sed 's/",//g'`


sudo apt update

curl -fsSL https://get.docker.com | bash
sudo systemctl enable --now docker
systemctl status docker | grep "Active:"
sudo usermod -aG docker $USR

curl -SL https://github.com/docker/compose/releases/download/$VERSION_COMPOSE/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose 
