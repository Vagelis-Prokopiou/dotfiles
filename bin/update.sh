#!/bin/bash

# Download Viber, Teamviewer, Dropbox, Chrome:
# https://www.viber.com/en/products/linux
# https://www.teamviewer.com/en/download/linux/
# https://www.dropbox.com/install-linux
# https://www.google.com/chrome/browser/desktop/

# Variables:
user='va';
user_home="/home/${user}";
downloads_dir="/home/${user}/Downloads";
root_home='/root';
is_initial_install=false;
# is_initial_install=true;

# Drush.
function installDrush() {
	# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
	php -r "readfile('http://files.drush.org/drush.phar');" > drush
	# Test your install.
	php drush core-status;
	# Make `drush` executable as a command from anywhere. Destination can be anywhere on $PATH.
	sudo chmod +x drush;
	sudo mv drush /usr/local/bin;
	#### ----- Enrich the bash startup file with completion and aliases #####.
	drush init;
}

# Composer
function installComposer() {
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar /usr/local/bin/composer;
}

# Drupal Console
function installDrupalConsole() {
	# php -r "readfile('https://drupalconsole.com/installer');" > drupal.phar;
	curl -O https://drupalconsole.com/installer;
	sudo mv installer /usr/local/bin/drupal;
	sudo chmod +x /usr/local/bin/drupal;
	sudo drupal init;
}

# NodeJS
function installNodeJS() {
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -;
	sudo aptitude install -y nodejs;
}

# Node modules
function installNodeModules {
	sudo npm install -g \
	yarn \
	webpack \
	gulp \
	gulp-sass \
	gulp-sourcemaps \
	gulp-autoprefixer \
	node-sass-globbing \
	gulp-plumber \
	browser-sync \
	gulp-sass-glob \
	jshint \
	breakpoint-sass;

	# The latest node-sass that is inside gulp-sass cretates a problem with the compass-mixins.
	# Install globally the node-sass@3.4.2, and copy it in gulp-sass/node_modules.
	# sudo npm install -g node-sass@3.4.2;
	# sudo cp -r /usr/lib/node_modules/node-sass/ /usr/lib/node_modules/gulp-sass/node_modules/;
	# Remove all the info files of the node modules.
	# sudo find /usr/lib/node_modules -type f -name '*.info' | xargs sudo rm;

	# ----- Extra node modules -----
	# gulp-postcss \
	# lost \
	# gulp-uncss \
	# gulp.spritesmith \
	# gulp-uglify \
	# gulp-image-optimization \
	# compass-mixins \
	# gulp-group-css-media-queries \

	# Delete the .info files.
	sudo find /usr/lib/node_modules/ -iname "*.info" -exec sudo rm "{}" \+;
	echo "All *.info files were successfully deleted.";
}

# If it is initlia setup after a fresh install.
if  $is_initial_install; then
	############################################
	# Debian testing repository!!!
	# deb ftp://ftp.gr.debian.org/debian/ testing main contrib  non-free
	############################################

	############################################
	# ----- Edit the Debian sources list.
	############################################
# 	echo "deb http://ftp.gr.debian.org/debian/ stretch main contrib non-free
# deb-src http://ftp.gr.debian.org/debian/ stretch main contrib non-free

# deb http://security.debian.org/debian-security stretch/updates main contrib non-free
# deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free

# deb http://ftp.gr.debian.org/debian/ stretch-updates main contrib non-free
# deb-src http://ftp.gr.debian.org/debian/ stretch-updates main contrib non-free" > /etc/apt/sources.list;

	# Add va to sudoers.
	# echo 'va	ALL=(ALL:ALL) ALL' >> /etc/sudoers;

	cp /etc/fstab /etc/fstab.bak;
	echo "
# The following is the disk that has the torrents folder.
UUID=1A52BBE952BBC7B1   /media/va/local_disk   ntfs    auto,user,exec,rw,suid,noatime,relatime   0   0
UUID=52AF7EBE182A63E2   /media/va/52AF7EBE182A63E2   ntfs    auto,user,exec,rw,suid,noatime,relatime    0   0" 	>> /etc/fstab;

	############################################
	# ----- Install Sublime Text 3
	############################################
	# Instructions for Greek spell checking:
	# https://www.sublimetext.com/docs/3/spell_checking.html
	# https://github.com/titoBouzout/Dictionaries/blob/master/Greek.dic
	# # Sublime 3 (3126)
	# wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb && dpkg -i sublime*.deb -y;
	# # Install Monokai-Midnight as theme: http://colorsublime.com/theme/Monokai-Midnight
 #    wget 'http://colorsublime.com/theme/download/61775';
 #    sudo mkdir -p /root/.config/sublime-text-3/Packages/Themes;
 #    sudo mkdir -p ${user_home}/.config/sublime-text-3/Packages/Themes;
 #    sudo cp 61775 /root/.config/sublime-text-3/Packages/Themes/Monokai-Midnight.tmTheme;
 #    sudo cp 61775 ${user_home}/.config/sublime-text-3/Packages/Themes/Monokai-Midnight.tmTheme;
 #    sudo rm 61775;


	############################################
	# ----- Install Sublime Text 3 package manager
	############################################
	# Visit this url: https://packagecontrol.io/installation

	############################################
	# ----- Various maintenance tasks.
	############################################
	apt-get install -y sudo;
	apt-get install -y aptitude;
	aptitude update -y;
	aptitude upgrade -y;
	aptitude install -y curl;
	aptitude install -y build-essential;
	aptitude install -y p7zip-full;
	aptitude install -y keepass2;
	# aptitude install -y git git-flow;
	aptitude install -y qalculate;
	aptitude install -y qbittorrent;
	aptitude install -y apt-transport-https;
	# Delete all Gnome games.
	sudo aptitude purge gnome-games;
	sudo aptitude purge -y inkscape;

	# Google Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
	sudo dpkg -i --force-depends ${downloads_dir}/google-chrome-stable_current_amd64.deb;
	sudo apt-get install -y -f;
	sudo rm ${downloads_dir}/google-chrome-stable_current_amd64.deb;

	# Skype
	sudo dpkg --add-architecture i386 && sudo aptitude update;
	sudo aptitude install -y libc6:i386 libqt4-dbus:i386 libqt4-network:i386 libqt4-xml:i386 libqtcore4:i386 libqtgui4:i386 libqtwebkit4:i386 libstdc++6:i386 libx11-6:i386 libxext6:i386 libxss1:i386 libxv1:i386 libssl1.0.0:i386 libpulse0:i386 libasound2-plugins:i386;
	# wget http://www.skype.com/go/getskype-linux-deb;
	sudo dpkg -i ${downloads_dir}/skype*.deb;
	sudo rm ${downloads_dir}/skype*.deb;

	# Dropbox
	# wget 'https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_amd64.deb';
	sudo sudo dpkg -i --force-depends ${downloads_dir}/*dropbox*.deb;
	sudo apt-get install -y -f;
	sudo rm ${downloads_dir}/*dropbox*.deb;

	# Viber
	sudo aptitude install -y libqt5gui5;
	# wget 'http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb';
	sudo dpkg -i ${downloads_dir}/viber.deb;
	sudo rm ${downloads_dir}/viber.deb;

	# Teamviewer
	# See: https://www.teamviewer.com/en/help/363-how-do-i-install-teamviewer-on-my-linux-distribution
	# See: https://www.linuxbabe.com/desktop-linux/install-teamviewer-debian-8
	# wget 'https://downloadus2.teamviewer.com/download/version_12x/teamviewer_12.0.71510_i386.deb';
	sudo dpkg -i ${downloads_dir}/teamviewer*.deb;
	# sudo dpkg -i --force-depends "teamviewer*.deb";
	sudo apt-get install -y -f;
	# teamviewer --daemon start;
	sudo rm ${downloads_dir}/teamviewer*.deb;

	# Youtube-dl.
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl;
	sudo chmod a+rx /usr/local/bin/youtube-dl;

	# Import and edit pdfs in Libreoffice Draw.
	# sudo aptitude install -y libreoffice-pdfimport;

	# Nautilus plugin for opening terminals in arbitrary paths.
	# sudo aptitude install -y nautilus-open-terminal;

	# This is needed for Dropbox.
	sudo aptitude install -y python-gpgme;

	# This fixes the error when using Sublime for git commits && needed for PhpStorm.
	sudo apt-get install -y libcanberra-gtk-module;

	# Purges.
	# sudo aptitude purge -y postgresql*;

	# Drivers for AMD GPU.
	# sudo aptitude install firmware-linux-nonfree libgl1-mesa-dri xserver-xorg-video-ati;

	# Create a template txt, for use in right click context.
	touch ${user_home}/Templates/new_file.txt;

	##############################################
	# ----- LAMP on Debian.
	##############################################
	sudo aptitude -y install apache2;
	sudo aptitude -y install mariadb-server;
	sudo aptitude -y install mariadb-client;
	sudo aptitude -y install php7.0;
	sudo aptitude -y install php7.0-mysql;
	sudo aptitude -y install libapache2-mod-php7.0;
	sudo aptitude -y install phpmyadmin;
	sudo aptitude -y install php7.0-xdebug;
	sudo a2enmod rewrite;
	sudo service apache2 restart;
	sudo apt --fix-broken install;

	# If not able to login to phpmyadmin with root, run the following query:
	# use mysql;
	# update user set password=PASSWORD("NEWPASSWORD") where User='root';
	# GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root';
	# FLUSH PRIVILEGES;

	if [ ! -f /etc/apache2/apache2.conf.bak ]; then
    	sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak;
		sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf;
	fi

	# For right-click archive extraction.
	# sudo aptitude install -y nemo-fileroller;

	# For Keepass2 auto-typing.
	# command -v > /dev/null 2>&1 xdotool || sudo aptitude install -y xdotool;

	sudo aptitude install -y linux-headers-$(uname -r);

	# Tool to manipulate images for the web!!!.
	# sudo aptitude install -y imagemagick;

	# sudo aptitude install -y mesa-vdpau-drivers;

	# Hardware info and sensors.
	# sudo aptitude install -y hardinfo;

	# See: https://www.cyberciti.biz/faq/howto-linux-get-sensors-information/
	# sudo aptitude install -y lm-sensors;

	# See also psensor and sensors-applet here: http://askubuntu.com/questions/15832/how-do-i-get-the-cpu-temperature.

	installDrush;
	installComposer;
	installDrupalConsole;
	installNodeJS;
	# installNodeModules;

# Non initial setup.
else
	# installDrush;
	# installComposer;
	# installDrupalConsole;
	# installNodeJS;

	sudo aptitude -y update;
	sudo aptitude -y upgrade;
	# sudo aptitude -y dist-upgrade;
	sudo apt-get -y autoremove;
	sudo apt-get -y check;
	sudo aptitude -y clean;
	sudo aptitude -y autoclean;
	sudo aptitude install -y -f;
	# Check for broken package(s).
	sudo dpkg --audit;

	# Update Composer
	sudo -H composer self-update;

	# Update Drupal Console.
	sudo drupal self-update;

	# Remove the torrent files from Downloads.
	rm ${user_home}/Downloads/*.torrent 2> /dev/null;
fi

sudo service bluetooth stop;

# Remove all the caches.
function clear-caches() {
	sudo rm -rf ${user_home}/drush-backups/*;
	sudo rm -rf /root/drush-backups/*;
	sudo find /var/www -iname "*.gz" | grep -v "*.sql.gz" | xargs sudo rm -r;
	sudo find /var/www/html -iname ".com.google.Chrome*" | xargs sudo rm -r;
	sudo find /var -type f -name '*log' | while read file; do echo -n > "$file"; done;
	sudo find /root /home /var/www "$dir" -ipath "*/.cache/*" -type f -delete;
	sudo find /root /home /var/www "$dir" -ipath "*/cache/*" -type f -delete;
	sudo find /root /home /var/www "$dir" -ipath "*/tmp/*" -type f -delete;
	sudo find /var/www/ -path "*/devel_themer/*" -delete;
	sudo find /root /home -name "*.log"  -delete;
}
clear-caches;


# http://ubuntuhandbook.org/index.php/2016/05/remove-old-kernels-ubuntu-16-04/
# List all kernels excluding the current booted:
old_kernels=$(dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r));
if [[ $old_kernels == '' ]]; then
	echo -e "\nThere are no old/unused kernels.\n";
else
	echo -e "\nThere are old kernels that need to be taken care of!!!\n";
fi


# ----- Install Java 8 for PhpStorm -----
# Edit /etc/apt/sources.list and add these lines (you may ignore line with #)
# Backport Testing on stable
# JDK 8
# sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak;
# echo 'deb http://ftp.de.debian.org/debian jessie-backports main' >> /etc/apt/sources.list;
# aptitude update
# aptitude install openjdk-8-jdk
# sudo update-alternatives --config java


# ----- Enable mssql in PHP. -----
# See: https://coderwall.com/p/21uxeq/connecting-to-a-mssql-server-database-with-php-on-ubuntu-debian
# sudo aptitude install freetds-common freetds-bin unixodbc php5-sybase;
# sudo service apache2 restart;

# ----- Install these before installing Virtualbox -----
# sudo aptitude install -y libqt5opengl5 libqt5printsupport5 libqt5widgets5 libqt5x11extras5;

##############################################
# ----- Guest additions on Virtualbox.
##############################################
# First install headers and build essential.
#sh /media/cdrom/VBoxLinuxAdditions.run;
#sudo reboot;

# ----- Various -----
############################################
# ----- Wifi on laptop Debian!!! Source: #https://wiki.debian.org/iwlwifi#Intel_Wireless_WiFi_Link.2C_Wireless-N.2C_Advanced-N.2C_Ultimate-N_devices
############################################
 #sudo aptitude update && aptitude install firmware-iwlwifi;
 #modprobe -r iwlwifi ; modprobe iwlwifi;

############################################
# ----- Install Keepass && Keefox
############################################
# sudo aptitude install keepass2;
# Install the 'CKP' extension for the Chrome.

##############################################
# ----- Mount a LAN location to my filesystem.
##############################################
# mount -t cifs //target_ip_address/name_of_folder_in_samba.conf /local_mount_location -o user=root
# mount -t cifs //server/www /mnt/smb -o user=root
# mount -t cifs //192.168.1.75/www /mnt/smb -o user=root

##############################################
# ----- Various.
##############################################
# Kill xserver.
# CTRL+ALT+F2 login as root
# /etc/init.d/gdm stop; install the drivers
# /etc/init.d/gdm start; and I'm back in business.


##############################################
# ----- Create ssh key pair
##############################################
# ssh-keygen -t rsa -b 4096 -C "drz4007@gmail.com"

# Copy ssh key to clipboard
# cat ~/.ssh/id_rsa.pub | xclip -sel clip

#### ----- To mount Smba shares #####.
# sudo aptitude install -y cifs-utils;

# All about printing. See: https://wiki.debian.org/PrintQueuesCUPS#Print_Queues_and_Printers
# sudo aptitude install -y task-print-server;

# aptitude install -y bum; # bootup manager
# sudo aptitude install ttf-mscorefonts-installer;

# Includes mysqldbcompare
# sudo aptitude install -y mysql-utilities;

# Required when installing Python from source.
# sudo aptitude install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev;

# Needed for digitally signing android apps.
# sudo aptitude install -y zipalign;

# Record the desktop.
# sudo aptitude install -y recordmydesktop;
# To record the sound see https://ubuntuforums.org/showthread.php?t=1118019

# ----- Database error after updating to 5.7 from the MySQL repo. -----
# Error
# SQL query: Edit Edit
# SHOW VARIABLES LIKE 'character_set_results'
# MySQL said: Documentation
#1146 - Table 'performance_schema.session_variables' doesn't exist
#1682 - Native table 'performance_schema'.'session_variables' has the wrong structure
# Solution: Run "sudo mysql_upgrade -u root -p --force && sudo service mysql restart";
# ----- Database error after updating to 5.7 from the MySQL repo (end). -----
