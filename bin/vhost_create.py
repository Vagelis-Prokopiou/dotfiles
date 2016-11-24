import os
import subprocess
import socket

domain = raw_input('Please enter the domain name to create: ')

domains = []
domains.append(domain)


def create_dirs():
    ''' Create the directory structure. '''
    for name in domains:
        if not os.path.isdir('/var/www/html/vhosts/' + name):
            os.mkdir('/var/www/html/vhosts/' + name)
            os.mkdir('/var/www/html/vhosts/' + name + '/public_html/')
            os.mkdir('/var/www/html/vhosts/' + name + '/logs/')
            create_conf_files(name)
            create_index_files(name)

            # Enable the site (3.4 Python version)
            os.system("a2ensite " + name + ".local")

            # Enable the site (3.5 Python version)
            # subprocess.run(['a2ensite', name + '.local'], check=True)


            # Write to the hosts file.
            write_hosts(name)
        else:
            print('{0} already exists. Skipping...'.format(name))


    # Restart apache (3.4 Python version)
    os.system("service apache2 restart")

    # Restart apache (3.5 Python version)
    # subprocess.run(['service', 'apache2', 'restart'], check=True)


def write_hosts(name):
    ''' Write the Windows hosts file. '''
    ip = [(s.connect(('8.8.8.8', 53)), s.getsockname()[0], s.close()) for s in
          [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]
    # with open('/media/sf_C_DRIVE/Windows/System32/drivers/etc/hosts', 'a') as file:
    with open('/etc/hosts', 'a') as file:
        file.write('\n{0} {1}.local\n'.format(ip, name))


def create_index_files(name):
    ''' Create the index files. '''
    with open('/var/www/html/vhosts/' + name + '/public_html/index.html', 'w') as file:
        text = "<h1>{0}.local has been created successfully.</h1>".format(name)
        file.write(text)


def create_conf_files(name):
    ''' Create the configuration files at /etc/apache2/sites-available. '''
    with open('/etc/apache2/sites-available/' + name + '.local.conf', 'w+') as file:
        text = """<VirtualHost *:80>
      # Enable the site with sudo a2ensite site_name && sudo /etc/init.d/apache2 restart
      # Enable the site with sudo a2ensite {0}.local && sudo /etc/init.d/apache2 restart
      ServerName {0}.local
      ServerAdmin webmaster@localhost
      DocumentRoot /var/www/html/vhosts/{0}/public_html/
      <Directory /var/www/html/vhosts/{0}/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
      </Directory>
      LogLevel info warn
      ErrorLog /var/www/html/vhosts/{0}/logs/error.log
      CustomLog /var/www/html/vhosts/{0}/logs/access.log combined
    </VirtualHost>""".format(name)
        file.write(text)


def main():
    if os.path.isdir('/var/www/html/vhosts/'):
        create_dirs()
    else:
        os.mkdir('/var/www/html/vhosts/')
        create_dirs()


if __name__ == '__main__':
    main()
