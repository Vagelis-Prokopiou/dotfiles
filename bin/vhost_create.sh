#!/bin/env bash

if [[ "$1" ]]; then

  base_path='/var/www/html/vhosts/';
  domain="$1";

  if [[ ! -d "${base_path}" ]]; then
    sudo mkdir "${base_path}";
  fi

  if [[ ! -d "${base_path}/${domain}" ]]; then
    sudo mkdir "${base_path}/${domain}";
    sudo mkdir "${base_path}/${domain}/public_html/";
    sudo mkdir "${base_path}/${domain}/logs/";
    # Create an index file.
    sudo echo "<h1>${domain}.local has been created successfully.</h1>" > "${base_path}/${domain}/public_html/index.html";

    # Create the Apache config files.
    sudo echo '
    <VirtualHost *:80>
        # Enable the site with sudo a2ensite site_name && sudo /etc/init.d/apache2 restart
        # Enable the site with sudo a2ensite test.local && sudo /etc/init.d/apache2 restart
        ServerName test.local
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/vhosts/test/public_html/
        <Directory /var/www/html/vhosts/test/public_html>
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>
        LogLevel info warn
        ErrorLog /var/www/html/vhosts/test/logs/error.log
        CustomLog /var/www/html/vhosts/test/logs/access.log combined
      </VirtualHost>' > "/etc/apache2/sites-available/${domain}.local.conf";


      # Enable the site.
      sudo a2ensite "${domain}.local";

      # Restart Apache.
      sudo service apache2 restart;

      echo "Done.";
      echo "You can access the site at http://${domain}.local/";
  else
    echo "${domain} already exists. Skipping...";
  fi
else
  echo "Usage: vhost-create <hostName>"
fi
