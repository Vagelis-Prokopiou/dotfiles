#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# Purge the previous installation.
sudo systemctl stop apache2;
sudo systemctl stop mysql;

sudo apt purge -y mariadb-server apache2 php7*;

sudo apt --fix-broken install;
sudo apt -y purge apache2*;
sudo apt -y purge mariadb*;
sudo apt -y purge php*;
sudo apt -y purge phpmyadmin;
sudo rm -rf /etc/apache2;
sudo rm -rr /etc/phpmyadmin;
sudo rm -rf /etc/php;
sudo rm -rf /var/lib/php/;
sudo apt -y autoremove;

# Install.
echo "Installing...";
sudo apt install -y mariadb-server mariadb-client;
sudo apt install -y php7.0 php7.0-mysql php7.0-xdebug;
sudo apt install -y apache2 apache2-mod-php7.0;
sudo apt install -y phpmyadmin;    
sudo a2enmod rewrite;
sudo systemctl restart apache2;
sudo apt --fix-broken install;
mysql -u root -p'root' -e "use mysql; update user set password='root' where User='root'; GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root'; FLUSH PRIVILEGES;";
