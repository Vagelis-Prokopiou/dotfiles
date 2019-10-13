#! /bin/bash

sudo apt install -y php;
application="Drush";

githubUrl="https://github.com/drush-ops/drush/releases"; \
latestVersion=$(curl ${githubUrl} | grep '<a href="/drush-ops/drush/releases/download/' | head -1 | sed 's|\(^.*download/\)||; s|/drush.phar.*||'); \
installedVersion=$(drush --version | sed 's/ Drush Version   :  //i; s/ \+//g');
downloadUrl="https://github.com/drush-ops/drush/releases/download/${latestVersion}/drush.phar";

if [[ "${latestVersion}" != "${installedVersion}" ]]; then
	echo -e "\nDownloading the latest ${application} version...\n";
	curl -L -O "${downloadUrl}";
	php drush.phar core-status;
	chmod +x drush.phar;
	sudo mv drush.phar /usr/local/bin/drush;
	drush init;
else
	echo -e "\nYou are using the latest ${application} version (${latestVersion}).\n";
fi