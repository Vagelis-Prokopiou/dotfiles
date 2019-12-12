#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

command -v composer > /dev/null 2>&1 || install-composer.sh;
sudo apt install -y php-mysql && sudo systemctl restart apache2;
sudo apt install -y php-xml;
sudo apt install -y php-imagick;
sudo apt install -y php-json;
sudo apt install -y php-curl;
sudo apt install -y php-mbstring;
sudo apt install -y php-gd;


if [[ ! "$1" ]]; then
    echo "Usage: $0 <database_name>";
    exit 1;
fi

user_pass=root;
sudo rm -rf ./*;
sudo rm -rf ./.*;

composer create-project drupal/recommended-project . --no-interaction;
composer install;

mkdir -p web/sites/default/files;
chmod -R 777 web/sites/default/files;

rm -rf .git;
sudo chown -R va:www-data .;
git init;
git add .;
git commit -m 'Initial commit';

mysql -u${user_pass} -p${user_pass} -e "DROP DATABASE IF EXISTS $1; CREATE DATABASE $1;";
# drush si -y standard --root=./web --db-url=mysql://${user_pass}:${user_pass}@localhost:3306/${1} --account-name ${user_pass} --account-pass ${user_pass};
drush si -y standard --db-url=mysql://${user_pass}:${user_pass}@localhost:3306/${1};
drush cr;
