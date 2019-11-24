#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# See: https://www.drupal.org/node/2487215
if [[ $1 ]]; then
    drush sql-query "DELETE from system where name = '"$1"' AND type = 'module';";
    exit 1;
else
    echo "Usage: drupal-fix-missing-module <moduleName>";
    exit 1;
fi