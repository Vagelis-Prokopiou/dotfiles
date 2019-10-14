#! /bin/bash

sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common;
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable";
sudo apt  update -y;
sudo apt install -y docker-ce;
