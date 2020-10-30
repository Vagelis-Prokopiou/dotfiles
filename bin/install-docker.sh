#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

sudo apt-get remove docker docker-engine docker.io containerd runc;
sudo apt-get update;
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common;
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable";
sudo apt  update -y;
sudo apt install -y docker-ce;
sudo usermod -aG docker $USER;

