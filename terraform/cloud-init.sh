#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND noninteractive

apt -y update
apt -y upgrade
apt -y autoremove
apt -y install apt-transport-https

# Install Docker
apt -y install docker.io
systemctl enable --now docker
usermod -aG docker github

# Add SSH Keys
curl -fsSl https://github.com/kborovik.keys | tee -a /home/github/.ssh/authorized_keys
