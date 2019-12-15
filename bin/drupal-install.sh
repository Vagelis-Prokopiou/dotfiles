#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# Check for composer.
command -v composer > /dev/null 2>&1 || install-composer.sh;

# Check for PHP.
# Todo: Extract PHP dependencies to a respective script.
sudo apt install -y php-mysql && sudo systemctl restart apache2;
sudo apt install -y php-xml;
sudo apt install -y php-imagick;
sudo apt install -y php-json;
sudo apt install -y php-curl;
sudo apt install -y php-mbstring;
sudo apt install -y php-gd;

# Define variables.
db_user_pass="root";
database=$(pwd | sed 's|.*www/||; s|/public_html||; s|\.|_|');

# Clear the current directory.
sudo rm -rf ./* > /dev/null;
sudo rm -rf ./.* > /dev/null;

# Install Drupal.
composer create-project drupal/recommended-project . --no-interaction;
composer install;

# Make the missing directories.
mkdir ./tmp;
mkdir -p web/sites/default/files;
chmod -R 775 web/sites/default/files;

# Create .gitignore
touch .gitignore;
{ echo '.idea'; \
  echo 'core'; \
  echo 'module/contrib/*'; \
  echo 'themes/contrib/*'; \
  echo '**/*/sites/default/*'; \
} >> .gitignore;

# Update the owner.
sudo chown -R va:www-data .;

# Create a new repo.
git init;
git add .;
git commit -m 'Initial commit';

# Create the database.
mysql -u "${db_user_pass}" -p"${db_user_pass}" -e "DROP DATABASE IF EXISTS ${database}; CREATE DATABASE ${database};";
drush si -y standard --db-url=mysql://${db_user_pass}:${db_user_pass}@localhost:3306/"${database}" --account-name="${db_user_pass}" --account-pass="${db_user_pass}";
drush cr;


