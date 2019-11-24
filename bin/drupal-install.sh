#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [[ ! "$1" ]]; then
    echo "Usage: drupal-install <databaseName>";
    exit 1;
fi

user_pass=root;
rm -rf ./*;
rm -rf ./.*;

echo "Using https://github.com/drupal-composer/drupal-project.";
git clone https://github.com/drupal-composer/drupal-project.git . ;

sed -i 's|"web/|"./|g' composer.json;
composer install;
sed -i 's|/web/|/|g' .gitignore;
rm -rf .git;
git init;
chown -R www-data:www-data . ;
git add .;
git commit -m 'Initial commit';

mysql -u${user_pass} -p${user_pass} -e "DROP DATABASE IF EXISTS $1; CREATE DATABASE $1;";
drush si -y --db-url=mysql://${user_pass}:${user_pass}@localhost:3306/${1} --account-name ${user_pass} --account-pass ${user_pass};

exit 0;
