#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [[ ! "$1" ]]; then
    echo "Usage: $0 <database_name>";
    exit 1;
fi

database="$1";

command -v composer > /dev/null 2>&1 || install-composer.sh;
sudo apt install -y php-mysql && sudo systemctl restart apache2;
sudo apt install -y php-xml;
sudo apt install -y php-imagick;
sudo apt install -y php-json;
sudo apt install -y php-curl;
sudo apt install -y php-mbstring;
sudo apt install -y php-gd;

user_pass="root";
sudo rm -rf ./* > /dev/null;
sudo rm -rf ./.* > /dev/null;

composer create-project drupal/recommended-project . --no-interaction;
composer install;

mkdir ./tmp;
mkdir -p web/sites/default/files;
chmod -R 777 web/sites/default/files;

rm -rf .git;
touch .gitignore;
echo '.idea' >> .gitignore;
echo 'core' >> .gitignore;
echo 'module/contrib/*' >> .gitignore;
echo 'themes/contrib/*' >> .gitignore;
echo 'sites/default/*' >> .gitignore;

git init;
git add .;
git commit -m 'Initial commit';

mysql -u "${user_pass}" -p"${user_pass}" -e "DROP DATABASE IF EXISTS $1; CREATE DATABASE ${database};";
drush si -y standard --db-url=mysql://${user_pass}:${user_pass}@localhost:3306/"${database}" --account-name="${user_pass}" --account-pass="${user_pass}";
drush cr;

sudo chown -R va:www-data .;
