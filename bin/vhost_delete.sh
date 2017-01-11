#!/bin/bash

# Create a variable with the sitename.
echo "Provide the name of the vhost you want to delete, followed by [ENTER]:";
read vhost;

# Delete all files associated with this site.
sudo rm -r /var/www/html/vhosts/${vhost};
sudo rm "/etc/apache2/sites-available/${vhost}.local.conf";
sudo rm "/etc/apache2/sites-enabled/${vhost}.local.conf";

# Restart Apache.
sudo service apache2 restart;
echo "The ${vhost} vhost was deleted successfully.";
echo "Apache was restarted. All set.";
exit 0;
