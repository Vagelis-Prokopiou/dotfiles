#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>


curl https://drupalconsole.com/installer -L -o drupal.phar \
&& sudo mv drupal.phar /usr/local/bin/drupal \
&& sudo chmod +x /usr/local/bin/drupal \
&& echo "Drupal Console installed sucesfully."
