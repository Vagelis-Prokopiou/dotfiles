#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [ ! -f /etc/ssl/localcerts/apache.pem ] || [ ! -f /etc/ssl/localcerts/apache.key ]; then
  # Check https://wiki.debian.org/Self-Signed_Certificate
	mkdir -p /etc/ssl/localcerts;
  openssl req -new -x509 -days 365 -nodes -out /etc/ssl/localcerts/apache.pem -keyout /etc/ssl/localcerts/apache.key;
  chmod 600 /etc/ssl/localcerts/apache*;
  sudo a2enmod ssl;
  sudo systemctl restart apache2;
fi

# Check for a provided hostname argument.
if [[ ! "$1" ]]; then
  echo "Usage: $0 <hostName>";
  exit 1;
fi

user="va";
base_path="/home/${user}/www";
domain="$1";
docroot="${base_path}/${domain}/public_html/web";
logsdir="${base_path}/${domain}/logs";

if [[ -d "${base_path}/${domain}" ]]; then
  echo "${domain} already exists. Skipping...";
  exit 0;
fi

sudo mkdir -p "${docroot}";
sudo mkdir -p "${logsdir}";
# Create an index file.
echo "<h1>${domain}.local has been created successfully.</h1>" | sudo tee "${docroot}/index.html";

# Create the Apache config files.
echo "<VirtualHost *:443>
  SSLEngine On
  SSLCertificateFile /etc/ssl/localcerts/apache.pem
  SSLCertificateKeyFile /etc/ssl/localcerts/apache.key

  ServerName ${domain}.local
  DocumentRoot ${docroot}

  <Directory ${docroot}/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  LogLevel info warn
  ErrorLog ${logsdir}/error.log
  CustomLog ${logsdir}/access.log combined
</VirtualHost>" | sudo tee "/etc/apache2/sites-available/${domain}.local.conf";

# Enable the site.
sudo a2ensite "${domain}.local";

# Add the vhost to the vhosts file.
echo "127.0.0.1 ${domain}.local" | sudo tee --append /etc/hosts;

sudo chown -R va:www-data "${base_path}/${domain}";

# Restart Apache.
sudo systemctl restart apache2;
echo "You can access the site at https://${domain}.local/";
