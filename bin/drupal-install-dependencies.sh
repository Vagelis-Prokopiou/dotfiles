#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

#if [[ ! $1 ]]; then
#  echo "No version provided. Example usage: $0 7.4"
#  exit 1;
#fi

# Install composer
command -v composer >/dev/null 2>&1 || install-composer.sh

latest_php_version=$(apt search libapache2-mod-php | grep 'libapache2-mod-php[[:digit:]]' | sed 's|/.*||')
latest_php_version=$(echo "$latest_php_version" | sed 's|libapache2-mod-php||')

echo "latest_php_version: $latest_php_version"

sudo systemctl stop apache2
sudo systemctl stop php"${latest_php_version}"-fpm.service

sudo apt install --reinstall -y php
sudo apt install --reinstall -y php-mysql
sudo apt install --reinstall -y php-xml
sudo apt install --reinstall -y php-imagick
sudo apt install --reinstall -y php-json
sudo apt install --reinstall -y php-curl
sudo apt install --reinstall -y php-mbstring
sudo apt install --reinstall -y php-gd

# Install PHP version specific dependencies.
sudo apt install --reinstall -y libapache2-mod-php"${latest_php_version}" # This is the Apche2 php module to parse php files.
sudo apt install --reinstall -y php"${latest_php_version}"
sudo apt install --reinstall -y php"${latest_php_version}"-mysql
sudo apt install --reinstall -y php"${latest_php_version}"-xml
sudo apt install --reinstall -y php"${latest_php_version}"-imagick
sudo apt install --reinstall -y php"${latest_php_version}"-json
sudo apt install --reinstall -y php"${latest_php_version}"-curl
sudo apt install --reinstall -y php"${latest_php_version}"-mbstring
sudo apt install --reinstall -y php"${latest_php_version}"-gd

sudo systemctl start apache2
