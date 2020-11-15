#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND noninteractive

apt -y update
apt -y upgrade
apt -y autoremove
apt -y install apt-transport-https ca-certificates curl software-properties-common

# Install Docker
apt -y install docker.io
systemctl enable --now docker
usermod -aG docker github

# Add SSH Keys
curl -fsSl https://github.com/kborovik.keys | tee -a /home/github/.ssh/authorized_keys

# Install GitHub Actions Runner

su github && cd
mkdir actions-runner && cd actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v2.274.1/actions-runner-linux-x64-2.274.1.tar.gz
tar xzf ./actions-runner-linux-x64-2.274.1.tar.gz && rm -f ./actions-runner-linux-x64-2.274.1.tar.gz
