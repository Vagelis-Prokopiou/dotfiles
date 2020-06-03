#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [[ ! "$1" ]]; then
    echo "Usage: vhost-delete <hostName>";
    exit 1;
fi

user="va";
base_path="/home/${user}/www";
domain="$1";
domainSuffix="local.com";

# Disable the vhost.
sudo a2dissite "${domain}.${domainSuffix}" 2> /dev/null;

# Delete all files associated with this site.
sudo rm -rf "${base_path}/${domain}" 2> /dev/null;
sudo rm -rf /var/www/html/${domain} 2> /dev/null; # This is the old path.
sudo rm "/etc/apache2/sites-available/${domain}.${domainSuffix}.conf" 2> /dev/null;

# Clean the /etc/hosts
sudo sed -i "/${domain}.${domainSuffix}/d" /etc/hosts;

# Drop the database.
mysql -u root -proot --execute "DROP DATABASE IF EXISTS ${domain%.*};";

# Restart Apache.
sudo systemctl restart apache2;
echo "The ${domain}.${domainSuffix}  vhost was deleted successfully.";
echo "Apache was restarted. All set.";
