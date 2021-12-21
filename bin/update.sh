#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# Download Viber, Teamviewer, Dropbox, Chrome:
# https://www.viber.com/en/products/linux
# https://www.teamviewer.com/en/download/linux/
# https://www.dropbox.com/install-linux
# https://www.google.com/chrome/browser/desktop/

# Variables:
user='va';
user_home="/home/${user}";
is_initial_install=false;
# is_initial_install=true;

function installPHPUnit()
{
	wget https://phar.phpunit.de/phpunit.phar;
	chmod +x phpunit.phar;
	sudo mv phpunit.phar /usr/local/bin/phpunit;
	echo "PHPUNit installed.";
}

function installViber()
{
	# See http://drupaland.eu/article/installing-viber-debian-9
	# Get multiarch-support https://packages.debian.org/buster/amd64/multiarch-support/download
	wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb; \
	wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb; \
	sudo dpkg -i ./libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb; \
	sudo apt install -y libqt5gui5; \
	# sudo apt install -y multiarch-support; \ # Does not exist for Kali Linux
	sudo dpkg -i ./viber.deb;\
	sudo apt --fix-broken install -y;\
	sudo rm ./viber.deb;
}

function installComposer() { install-composer.sh; }

function installDrupalConsole() { install-drupal-console.sh; }

function installNodeJS()
{
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -;
	sudo apt install -y nodejs;
}

# If it is initlia setup after a fresh install.
if  $is_initial_install; then
	############################################
	# ----- Edit the Debian sources list.
	############################################
	echo "
deb http://ftp.gr.debian.org/debian/ stable main contrib non-free
deb-src http://ftp.gr.debian.org/debian/ stable main contrib non-free

deb http://ftp.gr.debian.org/debian/ stable-updates main contrib non-free
deb-src http://ftp.gr.debian.org/debian/ stable-updates main contrib non-free

deb http://security.debian.org/ stable/updates main
deb-src http://security.debian.org/ stable/updates main

deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main
" > /etc/apt/sources.list;

	# Add va to sudoers.
	echo 'va	ALL=(ALL:ALL) ALL' >> /etc/sudoers;

	cp /etc/fstab /etc/fstab.bak;
	echo "
	# The following is the disk that has the torrents folder.
	# UUID=1A52BBE952BBC7B1   /media/va/local_disk   ntfs    auto,user,exec,rw,suid,noatime,relatime   0   0
	# UUID=52AF7EBE182A63E2   /media/va/52AF7EBE182A63E2   ntfs    auto,user,exec,rw,suid,noatime,relatime    0   0" 	>> /etc/fstab;


	############################################
	# ----- Various maintenance tasks.
	############################################
	apt install -y sudo;
	sudo apt update -y;
	sudo apt upgrade -y;
	sudo apt install -y curl \
						build-essential \
						p7zip-full \
						p7zip-rar \
						unrar \
						keepass2 \
						qbittorrent \
						apt-transport-https \
						vim \
						git \
						smplayer \
						byobu; # This is for old kernels removal. See: # https://www.tecmint.com/remove-old-kernel-in-debian-and-ubuntu/

	sudo apt purge -y gnome-games \
					  inkscape \
					  evolution \
					  seahorse \
					  gnome-maps \
					  gnome-games \
					  gnome-contacts \
					  gnome-documents;

	# Google Chrome
	# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
	# sudo dpkg -i --force-depends ./google-chrome-stable_current_amd64.deb;
	# sudo apt install -y -f;
	# sudo rm ./google-chrome-stable_current_amd64.deb;

	# Dropbox
	# wget 'https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_amd64.deb';
	# sudo sudo dpkg -i --force-depends ./*dropbox*.deb;\
	# sudo apt install -y -f;\
	# sudo rm ./*dropbox*.deb;

	# Youtube-dl.
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl;
	sudo chmod a+rx /usr/local/bin/youtube-dl;

	# Import and edit pdfs in Libreoffice Draw.
	# sudo apt install -y libreoffice-pdfimport;

	# Nautilus plugin for opening terminals in arbitrary paths.
	# sudo apt install -y nautilus-open-terminal;

	# This is needed for Dropbox.
	# sudo apt install -y python-gpgme;

	# This fixes the error when using Sublime for git commits && needed for PhpStorm.
	sudo apt install -y libcanberra-gtk-module;

	# Purges.
	# sudo apt purge -y postgresql*;

	# Drivers for AMD GPU.
	sudo apt install -y firmware-linux-nonfree libgl1-mesa-dri xserver-xorg-video-ati;

	# Create a template txt, for use in right click context.
	touch ${user_home}/Templates/new_file.txt;

	# This is needed for running the sed tests while building
	sudo apt install valgrind;

	##############################################
	# ----- LAMP on Debian.
	##############################################
	# Define dynamicaly the current php version.
	# sudo apt-get install --reinstall apache2 php7.3 libapache2-mod-php7.3 php-gd php-mysql;
	# echo '<?php phpinfo(); ?>' | sudo tee /var/www/html/index.php;
	# sudo chown www-data:www-data /var/www/html/index.php;
	# sudo rm /var/www/html/index.html;
	# sudo systemctl restart apache2;



	sudo apt -y install apache2;
	sudo apt install -y mariadb-server;
	sudo apt install -y phpmyadmin;
	sudo apt -y install php-xdebug;
	sudo apt -y install php-dom; # This fixes the error "Class 'DOMDocument' not found", during Drupal tests execution.
	sudo a2enmod rewrite;
	sudo systemctl restart apache2;
	sudo apt --fix-broken install;
	# Fix the upload file size.
	find /etc -name php.ini -exec sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/g' "{}" \;

	# Grant all privileges to root user.
	# How to reset the password: https://robbinespu.github.io/eng/2018/03/29/Reset_mariadb_root_password.html
	mysql -u root -proot -e "use mysql; update user set password='root' where User='root'; GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root'; FLUSH PRIVILEGES;";

	if [ ! -f /etc/apache2/apache2.conf.bak ]; then
    	sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak;
		sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf;
	fi

	# For right-click archive extraction.
	# sudo apt install -y nemo-fileroller;

	# For Keepass2 auto-typing.
	command -v > /dev/null 2>&1 xdotool || sudo apt install -y xdotool;

	sudo apt install -y linux-headers-$(uname -r);

	# Tool to manipulate images for the web!!!.
	# sudo apt install -y imagemagick;

	~/bin/install-docker.sh;
	~/bin/install-drush.sh;
	installComposer;
	installDrupalConsole;
	# installNodeJS;
	# installViber;
	# ~/bin/install-teamviewer;
	installPHPUnit;

# Non initial setup.
else
	# ~/bin/install-drush.sh;
	# installComposer;
	# installDrupalConsole;
	# installNodeJS;
	# installViber;
	# ~/bin/install-teamviewer;
	# installPHPUnit;

	sudo apt -y update;
	sudo apt -y upgrade;
	# sudo apt -y dist-upgrade;
	sudo apt -y autoremove;
	sudo apt -y clean;
	sudo apt -y autoclean;
	sudo apt install -y -f;
	# Check for broken package(s).
	sudo dpkg --audit;

	# Update Composer
	sudo -H composer self-update;

	# Update Drupal Console.
	sudo drupal self-update;

	sudo youtube-dl --update;

	# Remove the torrent files from Downloads.
	rm ${user_home}/Downloads/*.torrent 2> /dev/null;
fi

# Remove all the caches.
function clear-caches() {
	echo
	echo "clear-caches started"
	sudo rm -rf ${user_home}/java_error*;
	sudo rm -rf ${user_home}/drush-backups/*;
	sudo rm -rf /root/drush-backups/*;
	sudo find /root /home -ipath "*/.cache/*" -type f -delete;
	sudo find /root /home -ipath "*/tmp/*" -type f -delete;
	sudo find /root /home -name "*.log" -delete;
	
	# Remove all the build artifacts of the Rust projects.
	find ${user_home}/projects/rust/ -type d -name target | while read dir; do rm -rf "$dir"; done;

	# Clear Brave caches.
	rm -rf ${user_home}/.config/BraveSoftware/Brave-Browser/Default/Service\ Worker/CacheStorage/*;
	rm -rf ${user_home}/.config/BraveSoftware/Brave-Browser/Greaselion/Temp/*;

	# Code related stuff
	rm -rf ${user_home}/.config/Code/.org.chromium.Chromium.*;
	rm -rf ${user_home}/.config/Code/Cache/*;
	rm -rf ${user_home}/.config/Code/Cached*/*;
	
	echo "clear-caches ended"
	echo
}
clear-caches;

# Remove old kernes
sudo purge-old-kernels --keep 2

# Manipulate services.
sudo service bluetooth stop;

# Run as the non-root user.
runuser -l ${user} -c 'rustup update';
