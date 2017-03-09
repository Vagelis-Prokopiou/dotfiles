#!/bin/bash

if [[ "$1" ]]; then

	vhost="$1";

	if [[ -d "/var/www/html/vhosts/${vhost}" ]]; then
		# Delete all files associated with this site.
		sudo rm -r /var/www/html/vhosts/${vhost};
		sudo rm "/etc/apache2/sites-available/${vhost}.local.conf";
		sudo rm "/etc/apache2/sites-enabled/${vhost}.local.conf";

		# Restart Apache.
		sudo service apache2 restart;
		echo "The ${vhost} vhost was deleted successfully.";
		echo "Apache was restarted. All set.";
		exit 0;
	else
		echo "No such vhost found.";
	fi
else
	echo "Usage: vhost-delete <hostName>"
fi

