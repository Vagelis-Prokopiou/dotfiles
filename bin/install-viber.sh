#!/usr/bin/env bash

# See http://drupaland.eu/article/installing-viber-debian-9
# Get multiarch-support https://packages.debian.org/buster/amd64/multiarch-support/download
curent_dir=$(pwd);
cd /tmp
sudo rm ./viber*;
sudo apt purge -y viber;
sudo rm -rf /home/va/.Viber*
wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb;
# wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb;
# sudo dpkg -i ./libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb;
# sudo apt install -y libqt5gui5;
# sudo apt install -y multiarch-support; \ # Does not exist for Kali Linux
sudo dpkg -i ./viber.deb;
sudo apt --fix-broken install -y;
sudo rm ./viber.deb;
