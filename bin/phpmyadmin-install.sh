mkdir etc/nginx/ssl
apt update
apt upgrade -y
apt install nginx -y
apt install mariadb-server -y
apt install php-mbstring php-zip php-gd php-mysql php7.3-fpm -y

openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/42.pem -keyout /etc/nginx/ssl/42.key -subj "/C=IT/ST=Napoli/L=Napoli/O=4 /OU=Napoleone/CN=42"

wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-all-languages.tar.gz
tar xvf phpMyAdmin-4.9.7-all-languages.tar.gz

mv phpMyAdmin-4.9.7-all-languages/ phpmyadmin
mv phpmyadmin /var/www/html
rm phpMyAdmin-4.9.7-all-languages.tar.gz

service nginx start
service mysql start
service php7.3-fpm start

echo "CREATE DATABASE wpdb;" | mysql -u root --skip-password
echo "CREATE USER 'wpuser'@'localhost' identified by 'dbpassword';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/html
mv /tmp/wp-config.php /var/www/html/wordpress
rm latest.tar.gz

service php7.3-fpm start
service nginx start

bin/bash
