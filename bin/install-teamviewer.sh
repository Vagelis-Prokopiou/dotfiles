#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb;
sudo dpkg --add-architecture i386;
sudo apt-get update;
sudo dpkg -i --force-depends ./teamviewer*.deb;
sudo apt install -y -f;
sudo teamviewer --daemon start;
sudo rm ./teamviewer*.deb;
