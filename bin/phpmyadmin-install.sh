#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

latest=$(curl --silent https://www.phpmyadmin.net/ | grep href | grep files | head -n 1 | sed 's/.*href=//g; s/"//g' |  awk '{ print $1 }');
wget $latest;
unzip phpMyAdmin*;
rm -rf phpMyAdmin*.zip;
sudo mv phpMyAdmin* /usr/share/phpmyadmin;
sudo chown -R www-data:www-data /usr/share/phpmyadmin;

# Create the dababase.
sudo mysql -u root -p"root" -e "DROP DATABASE IF EXISTS phpmyadmin;";
sudo mysql -u root -p"root" -e "CREATE DATABASE phpmyadmin DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;";
sudo mysql -u root -p"root" -e "GRANT ALL ON phpmyadmin.* TO 'root'@'localhost' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;";

# Install the necessary php-extensions.
sudo apt install -y php-imagick php-phpseclib php-php-gettext php7.3-common php7.3-gd php7.3-imap php7.3-json php7.3-curl php7.3-zip php7.3-xml php7.3-mbstring php7.3-bz2 php7.3-intl php7.3-gmp;


sudo a2disconf phpmyadmin.conf && systemctl reload apache2;
echo "# phpMyAdmin default Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:dmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>

</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" | sudo tee /etc/apache2/conf-available/phpmyadmin.conf;

# Create temp folder.
sudo mkdir -p /var/lib/phpmyadmin/tmp;
sudo chown www-data:www-data /var/lib/phpmyadmin/tmp;

sudo a2enconf phpmyadmin.conf && sudo systemctl reload apache2;

apt ins
