#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND noninteractive

apt update
apt -y upgrade
apt -y autoremove
apt -y install apt-transport-https ca-certificates curl software-properties-common

# Install Docker
apt -y install docker.io
systemctl enable --now docker
usermod -aG docker github

curl -fsSl https://github.com/kborovik.keys | tee -a /home/github/.ssh/authorized_keys
