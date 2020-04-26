#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>
database="";
isLando=false;
db_user_pass="root";

if [ ! "$1" == 'lando' ]; then
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
  database=$(pwd | sed 's|.*www/||; s|/public_html||; s|\.|_|');
else
  lando start;
  isLando=true;
  echo 'Lando settings'
fi

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

if [ !isLando ]; then
  # Update the owner.
  sudo chown -R va:www-data .;
fi

# Create a new repo.
git init;
git add .;
git commit -m 'Initial commit';

if [ !isLando ]; then
  echo "Creating a database;"
  # Create the database.
  mysql -u "${db_user_pass}" -p"${db_user_pass}" -e "DROP DATABASE IF EXISTS ${database}; CREATE DATABASE ${database};";
fi

if [ !isLando ]; then
  drush si -y standard --db-url=mysql://${db_user_pass}:${db_user_pass}@localhost:3306/"${database}" --account-name="${db_user_pass}" --account-pass="${db_user_pass}";
drush cr;
else
  lando_credentials=drupal8;
  lando_host=database;
  lando drush si -y standard --db-url=mysql://"${lando_credentials}":"${lando_credentials}"@"${lando_host}":3306/"${lando_credentials}" --account-name="${db_user_pass}" --account-pass="${db_user_pass}";
fi


