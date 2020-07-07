#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [[ ! $1 ]]; then
  echo "No version provided. Example usage: $0 7.4"
  exit 1;
fi

command -v composer > /dev/null 2>&1 || install-composer.sh;

sudo apt install --reinstall -y php;
sudo apt install --reinstall -y php-mysql;
sudo apt install --reinstall -y php-xml;
sudo apt install --reinstall -y php-imagick;
sudo apt install --reinstall -y php-json;
sudo apt install --reinstall -y php-curl;
sudo apt install --reinstall -y php-mbstring;
sudo apt install --reinstall -y php-gd;

# Install PHP vesrion specific dependencies.
sudo apt install --reinstall -y php${1};
sudo apt install --reinstall -y php${1}-mysql;
sudo apt install --reinstall -y php${1}-xml;
sudo apt install --reinstall -y php${1}-imagick;
sudo apt install --reinstall -y php${1}-json;
sudo apt install --reinstall -y php${1}-curl;
sudo apt install --reinstall -y php${1}-mbstring;
sudo apt install --reinstall -y php${1}-gd;

sudo systemctl restart apache2;