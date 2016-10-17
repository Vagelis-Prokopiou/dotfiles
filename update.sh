#!/bin/bash

# Prepare a freshly installed Debian 8 for Drupal development.

############################################
# ----- Edit the Debian sources list.
############################################
# sudo echo "deb http://httpredir.debian.org/debian jessie main contrib non-free
# deb-src http://httpredir.debian.org/debian jessie main contrib non-free

# deb http://httpredir.debian.org/debian jessie-updates main contrib non-free
# deb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free

# deb http://security.debian.org/ jessie/updates main contrib non-free
# deb-src http://security.debian.org/ jessie/updates main contrib non-free" > /etc/apt/sources.list;

############################################
# ----- Install Sublime Text 3
############################################
# Sublime 3 (3114)
# wget wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb && dpkg -i sublime*.deb -y;
# Install Monokai-Midnight as theme.

############################################
# ----- Install Sublime Text 3 package manager
############################################
# Visit this url: https://packagecontrol.io/installation

############################################
# ----- Various maintenance tasks.
############################################
apt-get install sudo aptitude -y;
sudo apt-get update -y;
sudo apt-get upgrade -y;
sudo apt-get dist-upgrade -y;
sudo apt-get autoremove -y;
sudo apt-get autoclean -y;
sudo apt-get install -f;
sudo apt-get clean -y;
sudo apt-get install curl -y;
sudo apt-get install -y build-essential;
sudo apt-get install p7zip-full -y;
sudo apt-get install git -y;
sudo apt-get install git-flow -y;
sudo apt-get install qalculate -y;
# apt-get install bum -y; # bootup manager
# sudo apt-get install ttf-mscorefonts-installer;

# This fixes the error when using Sublime for git commits.
sudo apt-get install libcanberra-gtk-module -y;

#sudo apt-get purge libreoffice* -y;
#sudo apt-get purge chromium -y;
#sudo apt-get install trimage -y; # Tool to compress images for the web!!!.
#sudo apt-get install iceweasel filezilla libreoffice-writer libreoffice-calc keepass2 mono-complete flashplugin-nonfree -y;
#sudo apt-get install  keepass2 mono-complete flashplugin-nonfree -y;
#sudo apt-get install  keepass2 mono-complete -y;
#sudo update-flashplugin-nonfree --install;
sudo apt-get purge postgresql* -y;
sudo apt-get install linux-headers-$(uname -r) -y;

#### Remove all unused kernels with 1 command in debian based systems #####.
# sudo apt-get remove $(dpkg -l|egrep '^ii  linux-(im|he)'|awk '{print $2}'|grep -v `uname -r`);

# Includes mysqldbcompare
# sudo aptitude install mysql-utilities -y;

# Required when installing Python from source.
# sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev;

# Needed for digitally signing android apps.
# sudo aptitude install zipalign -y;

# This is needed for Dropbox.
# sudo apt-get install python-gpgme -y;

# Remove all the caches.
ARRAY=($(ls / | grep -v media)); for i in ${ARRAY[@]}; do find "$i" -path "*/Trash/*" -iname "*" | xargs sudo rm -r; done;

ARRAY=($(ls / | grep -v media)); for i in ${ARRAY[@]}; do find "$i" -path "*/.cache/*" -iname "*" | xargs sudo rm -r; done;

sudo find /home/ -path "*/drush-backups/*"  -iname "*" | xargs sudo rm -r;

ARRAY=($(ls / | grep -v media)); for i in ${ARRAY[@]}; do find "$i" -path "*/tmp/*" -type f -amin +10 | xargs sudo rm -r; done;

# sudo find /var/www/html/ -name '*.gz' | grep -v dbexport;
sudo find /var -iname "*.gz" | grep -v dbexport | xargs sudo rm -r;
sudo find /var -type f -name '*log' | while read file; do echo -n > "$file"; done;

#### ----- To mount Smba shares #####.
# sudo apt-get install cifs-utils -y;

#### ----- Install nodejs 4 #####.
#curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -;
#sudo apt-get install -y nodejs;

#### ----- Install jshint for sublime #####.
#sudo npm install -g jshint;

# Drivers for AMD GPU.
# sudo apt-get install firmware-linux-nonfree libgl1-mesa-dri xserver-xorg-video-ati

##############################################
# ----- LAMP on Debian.
##############################################
# sudo apt-get -y install apache2;
# sudo apt-get -y install mariadb-server mariadb-client;
# sudo apt-get -y install php5 php5-mysql libapache2-mod-php5 php5-curl;
# sudo apt-get -y install php-pear;
# sudo apt-get -y install phpmyadmin;
# sudo a2enmod rewrite;

#### ----- Install Drush 8 #####.
# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
# php -r "readfile('http://files.drush.org/drush.phar');" > drush

# Test your install.
# php drush core-status;

# Make `drush` executable as a command from anywhere. Destination can be anywhere on $PATH.
# chmod +x drush;
# sudo mv drush /usr/local/bin;

#### ----- Enrich the bash startup file with completion and aliases #####.
#drush init;

#### ----- Install all node modules globally. #####.
# The latest node-sass that is inside gulp-sass cretates a problem with the compass-mixins.
# Install globally the node-sass@3.4.2, and copy it in gulp-sass/node_modules.
# sudo npm install -g gulp-sass gulp gulp gulp-group-css-media-queries compass-mixins gulp-sourcemaps gulp-autoprefixer node-sass-globbing gulp-plumber browser-sync gulp-uncss gulp-uglify gulp-image-optimization gulp.spritesmith gulp-sass-glob gulp-postcss lost singularitygs breakpoint-sass;
# sudo npm install -g node-sass@3.4.2;
# sudo cp -r /usr/lib/node_modules/node-sass/ /usr/lib/node_modules/gulp-sass/node_modules/;
# Remove all the info files of the node modules.
# sudo find /usr/lib/node_modules -type f -name '*.info' | xargs sudo rm;


############################################
# ----- Wifi on laptop Debian!!! Source: #https://wiki.debian.org/iwlwifi#Intel_Wireless_WiFi_Link.2C_Wireless-N.2C_Advanced-N.2C_Ultimate-N_devices
############################################
 #sudo apt-get update && apt-get install firmware-iwlwifi;
 #modprobe -r iwlwifi ; modprobe iwlwifi;

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

##############################################
# ----- Guest additions on Virtualbox.
##############################################
# First install headers and build essential.
#sh /media/cdrom/VBoxLinuxAdditions.run;
#sudo reboot;

############################################
# ----- Install Keepass && Keefox
############################################
# sudo apt-get install keepass2;
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
# sudo apt-get install libqt5gui5
# and re-installing viber
# sudo apt-get install libqt5gui5 -y && wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb && sudo dpkg -i viber.debviber;

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

# ----- Install Java 8 for PhpStorm -----
# Edit /etc/apt/sources.list and add these lines (you may ignore line with #)
# Backport Testing on stable
# JDK 8
# sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak;
# echo 'deb http://ftp.de.debian.org/debian jessie-backports main' >> /etc/apt/sources.list;
# apt-get update
# apt-get install openjdk-8-jdk
# sudo update-alternatives --config java

# ----- Backup all databases -----
echo ''; \
echo "----- Exporting the databases to /home/va/Dropbox/dbs/$(echo $(date +%Y-%m-%d))/ -----"; \
echo ''; \
# mysqldump -uroot -proot --all-databases | gzip > /home/va/Dropbox/all_databases.sql.gz;
dbs=$(echo $( mysql -uroot -proot -e 'show databases;') | \
sed "s/Database//g; s/information_schema//g; \
s/performance_schema//g; \
s/phpmyadmin//g"; \
); \
mkdir /home/va/Dropbox/dbs/$(date +%Y-%m-%d) 2>/dev/null || echo "----- Directory /home/va/Dropbox/dbs/$(date +%Y-%m-%d) already exists."; \
IFS=' ' read -ra dbs_array <<< "$dbs"; \
for db in "${dbs_array[@]}"; do \
    # echo "$db"_$(date +%Y-%m-%dT%H:%M).sql.gz; \
    mysqldump -uroot -proot "$db" | gzip > /home/va/Dropbox/dbs/$(date +%Y-%m-%d)/"$db".sql.gz;
done;
echo '';
echo '----- Databases exported successfully -----';
echo '';
