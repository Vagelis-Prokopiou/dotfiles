#!/bin/bash

# Variables:
user='va';
user_home="/home/${user}";
root_home='/root';

# Check sed, grep, find, xargs.

function main-update() {
	############################################
	# ----- Install Sublime Text 3
	############################################
	# Sublime 3 (3126)
	# wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb && dpkg -i sublime*.deb -y;
	# Install Monokai-Midnight as theme.

	############################################
	# ----- Install Sublime Text 3 package manager
	############################################
	# Visit this url: https://packagecontrol.io/installation

	############################################
	# ----- Various maintenance tasks.
	############################################
	# command -v > /dev/null 2>&1 sudo || apt-get install -y sudo;
	command -v > /dev/null 2>&1 aptitude || sudo apt-get install -y aptitude;
	sudo aptitude update -y;
	sudo aptitude upgrade -y;
	# sudo aptitude dist-upgrade -y;
	sudo aptitude autoremove -y;
	sudo aptitude autoclean -y;
	sudo aptitude install -f;
	sudo aptitude clean -y;
	command -v > /dev/null 2>&1 curl || sudo aptitude install -y curl;
	command -v > /dev/null 2>&1 gcc || sudo aptitude install -y build-essential;
	command -v > /dev/null 2>&1 7z || sudo aptitude install -y p7zip-full;
	command -v > /dev/null 2>&1 keepass2 || sudo aptitude install -y keepass2;
	command -v > /dev/null 2>&1 git || sudo aptitude install -y git git-flow;
	# command -v > /dev/null 2>&1 qalculate || sudo aptitude install -y qalculate;

	# Delete all Gnome games.
	sudo aptitude purge -y aisleriot gnome-mahjongg gnome-mines gnome-sudoku;

	# For right-click archive extraction.
	# sudo aptitude install -y nemo-fileroller; # For right-click archive extraction.

	# For Keepass2 auto-typing.
	# command -v > /dev/null 2>&1 xdotool || sudo aptitude install -y xdotool;
	# sudo aptitude install -y linux-headers-$(uname -r);
	# sudo aptitude install trimage -y; # Tool to compress images for the web!!!.


	# Hardware info and sensors.
	# sudo aptitude install -y hardinfo;

	# See: https://www.cyberciti.biz/faq/howto-linux-get-sensors-information/
	# sudo aptitude install -y lm-sensors;

	# See also psensor and sensors-applet here: http://askubuntu.com/questions/15832/how-do-i-get-the-cpu-temperature.

	# Google Chrome (Ubuntu 16.04).
	if [[ ! $(which google-chrome) ]]; then
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
		sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb;
		sudo apt-get install -y -f;
		sudo rm google-chrome-stable_current_amd64.deb;
	fi

	# Teamviewer
	echo 'Teamviewer installation:';
	echo 'Download the package and run the following command:';
	echo 'sudo dpkg -i --force-depends teamviewer*.deb && sudo apt-get install -y -f && sudo rm teamviewer*.deb && teamviewer --daemon start';

	# ----- Install youtube-dl. -----
	function installYoutubeDL {
		# Install latest youtube-dl.
		sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl;
		sudo chmod a+rx /usr/local/bin/youtube-dl;
	}

	if [[ -a /usr/local/bin/youtube-dl ]]; then
		echo "youtube-dl is already installed."
		if [[ $(date +%d) == 1 || $(date +%d) == 15 ]]; then
			echo "Updating youtube-dl..."
			installYoutubeDL;
		fi
	else
		echo "Installing youtube-dl..."
		installYoutubeDL;
	fi

	# Import and edit pdfs in Libreoffice Draw.
	# sudo aptitude install -y libreoffice-pdfimport;

	# Nautilus plugin for opening terminals in arbitrary paths.
	# sudo aptitude install -y nautilus-open-terminal;

	# This is needed for Dropbox.
	# sudo aptitude install -y python-gpgme;

	# This fixes the error when using Sublime for git commits && needed for PhpStorm.
	# sudo aptitude install libcanberra-gtk-module -y;

	# Purges.
	# sudo aptitude purge postgresql* -y;

	# Drivers for AMD GPU.
	# sudo aptitude install firmware-linux-nonfree libgl1-mesa-dri xserver-xorg-video-ati;

	# Create a template txt, for use in right click context.
	touch ${user_home}/Templates/new_file.txt;

	##############################################
	# ----- LAMP on Debian.
	##############################################
	# command -v > /dev/null 2>&1 apache2 || sudo aptitude -y install apache2 mysql-server mysql-client mysql-workbench php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-curl php-pear phpmyadmin php7.0-xdebug && sudo a2enmod rewrite && sudo service apache2 restart;


	sudo aptitude -y install apache2 mysql-server mysql-client php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-curl php-pear phpmyadmin php7.0-xdebug && sudo a2enmod rewrite && sudo service apache2 restart;
	##############################################
	# ----- Error 'The requested URL /el was not found on this server.'
	##############################################
	# Edit '/etc/apache2/apache2.conf' and change the 'AllowOverride None' && restart apache (/etc/init.d/apache2 restart).
	# See: http://stackoverflow.com/questions/18740419/how-to-set-allowoverride-all.

	# <Directory /var/www/>
		# Options Indexes FollowSymLinks
		# AllowOverride All
		# Require all granted
	# </Directory>

	#See: https://www.digitalocean.com/community/tutorials/how-to-set-up-mod_rewrite-for-apache-on-ubuntu-14-04
	if [ ! -f /etc/apache2/apache2.conf.bak ]; then
    	sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak;
		sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf;
	fi

	# Install Drush.
	function installDrush {
		# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
		php -r "readfile('http://files.drush.org/drush.phar');" > drush
		# Test your install.
		php drush core-status;
		# Make `drush` executable as a command from anywhere. Destination can be anywhere on $PATH.
		chmod +x drush;
		sudo mv drush /usr/local/bin;
		#### ----- Enrich the bash startup file with completion and aliases #####.
		drush init;
	}

	if [[ -a /usr/local/bin/drush ]]; then
		echo "Drush is already installed."
		if [[ $(date +%d) == 1 || $(date +%d) == 15 ]]; then
			echo "Updating..."
			installDrush;
		fi
	else
		echo "Installing Drush..."
		installDrush;
	fi

	# ----- Install Composer. -----
	if [[ -a /usr/local/bin/composer ]]; then
		echo "Composer is already installed."
		echo "Updating..."
		sudo -H composer self-update
	else
		echo "Installing Composer..."
		php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
		php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;";
		php composer-setup.php;
		php -r "unlink('composer-setup.php');";
		mv composer.phar /usr/local/bin/composer;
	fi

	# ----- Install Drupal Console. -----
	if [[ -a /usr/local/bin/drupal ]]; then
		echo "Drupal Console is already installed."
		echo "Updating..."
		sudo drupal self-update;
	else
		echo "Installing Drupal Console..."
		curl https://drupalconsole.com/installer -L -o drupal.phar;
		sudo mv drupal.phar /usr/local/bin/drupal;
		sudo chmod +x /usr/local/bin/drupal;
	fi

	# ----- Install NodeJS. -----
	function installNodeJS {
		curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -;
		sudo aptitude install -y nodejs;
	}

	if [[ -a /usr/bin/node ]]; then
		echo "NodeJS is already installed."
		if [[ $(date +%d) == 1 || $(date +%d) == 16 ]]; then
			echo "Updating NodeJS..."
			installNodeJS;
		fi
	else
		echo "Installing NodeJS..."
		installNodeJS;
	fi

	# ----- Install all node modules globally. -----
	function installNodeModules {
		sudo npm install -g \
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

	if [[ -d /usr/lib/node_modules/gulp/ ]]; then
		echo "The NodeJS modules are already installed."
		if [[ $(date +%m) == 1 || $(date +%m) == 6 ]]; then
			echo "Updating the NodeJS modules..."
			# installNodeModules;
		fi
	else
		echo "Installing the NodeJS modules..."
		# installNodeModules;
	fi

	# If Dropbox exits.
	if [[ -d ${user_home}/Dropbox/ ]]; then
		# If folder for today does not exits, do the backup.
		if [[ ! -d ${user_home}/Dropbox/dbs/$(date +%Y-%m-%d)/ ]]; then
			# ----- Backup all databases -----
			echo ''; \
			echo "----- Exporting the databases to ${user_home}/Dropbox/dbs/$(echo $(date +%Y-%m-%d))/ -----"; \
			echo ''; \
			# mysqldump -uroot -proot --all-databases | gzip > ${user_home}/Dropbox/all_databases.sql.gz;
			dbs=$(echo $( mysql -uroot -proot -e 'show databases;') | \
			sed "s/Database//g; s/information_schema//g; \
			s/performance_schema//g; \
			s/d7//g; \
			s/d8//g; \
			s/mysql//g; \
			s/phpmyadmin//g"; \
			); \
			mkdir ${user_home}/Dropbox/dbs/$(date +%Y-%m-%d) 2>/dev/null; \
			IFS=' ' read -ra dbs_array <<< "$dbs"; \
			for db in "${dbs_array[@]}"; do \
			    # echo "$db"_$(date +%Y-%m-%dT%H:%M).sql.gz; \
			    mysql -uroot -proot -e "TRUNCATE TABLE $db.watchdog"; \
			    mysqldump -uroot -proot "$db" | gzip > ${user_home}/Dropbox/dbs/$(date +%Y-%m-%d)/"$db".sql.gz;
			done;
			echo '';
			echo '----- Databases exported successfully -----';
			echo '';

			# Remove the previous folders.
			find /home/va/Dropbox/dbs/* -type d ! -name "$(date +%Y-%m-%d)" -exec rm -r "{}" \+ 2>/dev/null;
		fi
	fi

	sudo chown -R ${user}:${user} ${user_home}/;


	# Remove the torrent files from Downloads.
	rm ${user_home}/Downloads/*.torrent 2> /dev/null;

	# How To Record and Share Linux Terminal Activity
	# See: http://linoxide.com/tools/record-share-linux-terminal/
	# sudo aptitude install asciinema;


	# ----- Check all services -----
	# service --status-all;
	# service --status-all | grep '+';
	sudo service bluetooth stop;



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
	# sudo aptitude install freetds-common freetds-bin unixodbc php7.0-sybase;
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
	# ----- Viber for Debian 8
	##############################################
	# Error message:
	# This application failed to start because it could not find or load the Qt platform plugin "xcb".
	# Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, wayland-egl, wayland, xcb.
	#
	# Fixed by installing:
	# sudo aptitude install libqt5gui5
	# and re-installing viber
	# sudo aptitude install libqt5gui5 -y && wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb && sudo dpkg -i viber.debviber;

	##############################################
	# ----- Skype for Debian 8
	##############################################
	# sudo dpkg --add-architecture i386;
	# sudo aptitude update;
	# sudo aptitude install libc6:i386 libqt4-dbus:i386 libqt4-network:i386 libqt4-xml:i386 libqtcore4:i386 libqtgui4:i386 libqtwebkit4:i386 libstdc++6:i386 libx11-6:i386 libxext6:i386 libxss1:i386 libxv1:i386 libssl1.0.0:i386 libpulse0:i386 libasound2-plugins:i386;
	# wget -O skype-install.deb http://www.skype.com/go/getskype-linux-deb;
	# sudo dpkg -i skype-install.deb;

	##############################################
	# ----- Create ssh key pair
	##############################################
	# ssh-keygen -t rsa -b 4096 -C "drz4007@gmail.com"

	# Copy ssh key to clipboard
	# cat ~/.ssh/id_rsa.pub | xclip -sel clip

	#### ----- To mount Smba shares #####.
	# sudo aptitude install cifs-utils -y;

	# All about printing. See: https://wiki.debian.org/PrintQueuesCUPS#Print_Queues_and_Printers
	# sudo aptitude install task-print-server -y;

	# aptitude install bum -y; # bootup manager
	# sudo aptitude install ttf-mscorefonts-installer;

	# Includes mysqldbcompare
	# sudo aptitude install mysql-utilities -y;

	# Required when installing Python from source.
	# sudo aptitude install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev;

	# Needed for digitally signing android apps.
	# sudo aptitude install zipalign -y;

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
}
main-update;

# All the packages for installation from source.
function software-update() {
	# Install the latest Vim from source.
	function vim-update() {
		# Make sure Vim is installed.
		command -v vim > /dev/null || sudo aptitude install -y vim vim-runtime;

		# curl GitHub for the latest version.
		echo -e "\nGetting the latest Vim...\n";
		vim_latest=$(curl https://github.com/vim/vim/releases | \
		grep '<span class="tag-name">' | \
		sed 's|<span class="tag-name">v||;' | \
		sed 's|</span>||' | \
		head -n 1 | \
		sed 's|[[:space:]]||g');

		# Get the installed version.
		vim_installed_version=$(vim --version | head -n 1 | awk '{ print $5 }');
		vim_installed_tag=$(vim --version | head -n 2 | tail -n 1 | awk '{ print $3 }' | sed 's|^[0-9]-|0|g');

		if [[ "$vim_latest" == "${vim_installed_version}.${vim_installed_tag}" ]]; then
			echo "-------------------------------------------------";
			echo "     Latest Vim (${vim_installed_version}.${vim_installed_tag}) already installed.";
			echo "-------------------------------------------------";
		else
			# Build latest Vim.
			# Needed for compiling Vim from source.
			sudo aptitude install -y libncurses5-dev;

			cd "/media/va/52AF7EBE182A63E2/src" 2> /dev/null || mkdir "/media/va/52AF7EBE182A63E2/src";

			# Download latest Vim.
			(git clone https://github.com/vim/vim.git && cd "/media/va/52AF7EBE182A63E2/src/vim/src") || cd "/media/va/52AF7EBE182A63E2/src/vim/src" && git reset --hard && git pull;

			# Configure and install.
			./configure > /dev/null;
			make > /dev/null;
			# make distclean > /dev/null;
			sudo make install > /dev/null;
			# sudo checkinstall > /dev/null;

			# Get the installed version again.
			vim_installed_version=$(vim --version | head -n 1 | awk '{ print $5 }');
			vim_installed_tag=$(vim --version | head -n 2 | tail -n 1 | awk '{ print $3 }' | sed 's|^[0-9]-|0|g');
			echo "--------------------------------------------------------------------------------";
			echo "     Latest Vim (${vim_installed_version}.${vim_installed_tag}) successfully installed. ";
			echo "--------------------------------------------------------------------------------";

			# Cleanup.
			# cd "/media/va/52AF7EBE182A63E2/src";
			# sudo rm -rf vim/;
		fi
	}

	# Install the latest Git from source.
	function git-update() {
		# Make sure Git is installed.
		command -v git > /dev/null || sudo aptitude install -y git;

		echo -e "\nGetting the latest Git...\n";
		git_latest=$(curl 'https://github.com/git/git/releases' | \
		grep '<span class="tag-name">' | \
		sed 's|<span class="tag-name">v||' | \
		sed 's|</span>||' | \
		head -n 1 | \
		sed 's|[[:space:]]||g');

		git_installed=$(git --version | awk '{print $3}' | sed 's|\(.*\)\([.a-z0-9]\{13\}\)|\1|; s/\.rc/-rc/');

		if [[ "$git_latest" = "$git_installed" ]]; then
			echo "-------------------------------------------------";
			echo "     Latest Git ($git_installed) already installed.";
			echo "-------------------------------------------------";
		else
			# Build the latest Git.
			# Needed for compiling Git from source.
			sudo aptitude install -y zlib1g-dev > /dev/null;
			sudo aptitude install -y libcurl4-openssl-dev > /dev/null;
			sudo aptitude install -y libssl-dev > /dev/null;
			sudo aptitude install libexpat1-dev > /dev/null;
			# fatal error: expat.h: No such file or directory

			cd "/media/va/52AF7EBE182A63E2/src" 2> /dev/null || mkdir "/media/va/52AF7EBE182A63E2/src";

			# Download the latest Git.
			(git clone git://git.kernel.org/pub/scm/git/git.git 2> /dev/null && cd "/media/va/52AF7EBE182A63E2/src/git/") || cd "/media/va/52AF7EBE182A63E2/src/git/" && git reset --hard && git pull;

			# Configure and install.
			make prefix=/usr > /dev/null;
			sudo make prefix=/usr install > /dev/null;

			# Get the installed version again.
			git_installed=$(git  --version | \
			awk '{print $3}' | \
			sed 's|\(.*\)\([.a-z0-9]\{13\}\)|\1|');
			echo "--------------------------------------------------------------------------------";
			echo "     Latest Git (${git_installed}) successfully installed. ";
			echo "--------------------------------------------------------------------------------";

			# Cleanup.
			# cd "/media/va/52AF7EBE182A63E2/src";
			# sudo rm -rf git/;


			# Continue with Git Flow since the Git binary gets overridden.
			cd "/media/va/52AF7EBE182A63E2/src";
			curl -OL https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh;
			sudo bash ./gitflow-installer.sh;
			rm -rf ./gitflow*;
		fi
	}

	function sed-update() {
		# Necessary for ACL support.
		sudo aptitude install -y libacl1-dev;

		sed_newest_version=`curl 'https://ftp.gnu.org/gnu/sed/?C=M;O=D' | \
		grep 'a href="sed-' | \
		head -n 1 | \
		sed 's|\(.*\)\(sed\)|\2|g; s|xz\.sig.*|xz|g'`;

		sed_newest_version_number=$( echo "${sed_newest_version}" | sed 's/sed-//g; s/\.tar.*//g' );

		sed_url="https://ftp.gnu.org/gnu/sed/${sed_newest_version}";

		sed_installed_version=$(sed --version | head -n 1 | awk '{ print $4 }');

		echo "sed_newest_version: $sed_newest_version";
		echo "sed_newest_version_number: $sed_newest_version_number";
		echo "sed_installed_version: $sed_installed_version";

		if [[ "$sed_newest_version_number" == "$sed_installed_version" ]]; then
			echo -e "\nThe newest sed is already installed.\n";
		else
			echo -e "Installing latest sed... Please, wait...";
			cd "/media/va/52AF7EBE182A63E2/src" 2> /dev/null || mkdir "/media/va/52AF7EBE182A63E2/src" && cd "/media/va/52AF7EBE182A63E2/src";
			curl -O $sed_url;
			tar -xf sed-*.tar.xz;
			cd sed-*/;
			./configure > /dev/null;
			make > /dev/null;
			sudo make install > /dev/null;
			cd ../;
			rm -rf sed*;
			echo -e "\nThe newest sed has been installed.\n";
		fi
	}

	function findutils-update() {
		findutils_newest_version=`curl 'https://ftp.gnu.org/pub/gnu/findutils/?C=M;O=D' | \
		grep 'a href="findutils-' | \
		head -n 1 | \
		sed 's|\(.*\)\(findutils\)|\2|g; s|gz\.sig.*|gz|g'`;

		findutils_newest_version_number=$( echo "${findutils_newest_version}" | sed 's/findutils-//g; s/\.tar.gz//g' );

		findutils_url="https://ftp.gnu.org/pub/gnu/findutils/${findutils_newest_version}";

		findutils_installed_version=$(find --version | head -n 1 | awk '{ print $4 }');

		echo "findutils_newest_version: $findutils_newest_version";
		echo "findutils_newest_version_number: $findutils_newest_version_number";
		echo "findutils_installed_version: $findutils_installed_version";

		if [[ "$findutils_newest_version_number" == "$findutils_installed_version" ]]; then
			echo -e "\nThe newest findutils are already installed.\n";
		else
			echo "Installing";
		fi
	}

	# Start the updates.
	vim-update;
	git-update;
	sed-update;
	# findutils-update;
}
# software-update;


# Remove all the caches.
function clear-caches() {
	sudo rm -rf ${user_home}/drush-backups/*;
	sudo rm -rf /root/drush-backups/*;
	sudo find /var -iname "*.gz" | grep -v "*.sql.gz" | xargs sudo rm -r;
	sudo find /var -type f -name '*log' | while read file; do echo -n > "$file"; done;
	sudo find /root /home /var "$dir" -ipath "*/.cache/*" -type f -delete;
	sudo find /root /home /var "$dir" -ipath "*/cache/*" -type f -delete;
	sudo find /root /home /var "$dir" -ipath "*/tmp/*" -type f -delete;
	sudo find /var/www/ -path "*/devel_themer/*" -delete;
	sudo find /root /home -name "*.log"  -delete;
}
clear-caches;

#### Remove all unused kernels with 1 command in debian based systems #####.
# sudo aptitude remove $(dpkg -l|egrep '^ii  linux-(im|he)'|awk '{print $2}'|grep -v `uname -r`);

# To list all installed Linux kernel images, type the following dpkg command:
# dpkg --list | egrep -i --color 'linux-image|linux-headers'

# http://ubuntuhandbook.org/index.php/2016/05/remove-old-kernels-ubuntu-16-04/
# List all kernels excluding the current booted:
old_kernels=$(dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r));
if [[ $old_kernels == '' ]]; then
	echo -e "\nThere are no old/unused kernels.\n";
else
	echo -e "\nThere are old kernels that need to be taken care of!!!\n";
fi
