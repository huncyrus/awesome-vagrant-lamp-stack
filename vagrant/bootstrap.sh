#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='root'
PROJECTFOLDER=''

# create project folder
if [ -n "$PROJECTFOLDER" ]; then
    sudo mkdir "/var/www/html/${PROJECTFOLDER}"
fi

# update / upgrade
echo "--------------------------";
echo "---- System Update";
echo "--------------------------";

sudo apt-get update
sudo apt-get -y upgrade

# Install system related stuffs
echo "--------------------------------------------------------";
echo "---- Basic utils & system related packages install";
echo "--------------------------------------------------------";
sudo apt-get install -y curl mc gcc build-essential libc6-dev autoconf automake aptitude htop
sudo apt-get install -y libsqlite3-dev python-software-properties
sudo apt-get install -y nfs-common nfs-kernel-server
sudo apt-get install -y openssl libssl-dev

echo "--------------------------------------------------------";
echo "---- Install cache solutions";
echo "--------------------------------------------------------";
sudo apt-get install -y mongodb memcached redis-server

# Install apache 2.5 and php 5.5
echo "--------------------------------------------------------";
echo "---- Dev environment install LAMP";
echo "--------------------------------------------------------";
sudo apt-get install -y apache2
sudo apt-get install -y php5 php5-gd php5-dev php-pear libpcre3-dev php-apc php5-cli libsqlite3-dev
sudo apt-get install -y libapache2-mod-php5 php5-mcrypt php5-curl php5-sqlite php5-xsl php5-intl php5-sqlite
sudo apt-get install -y php5-geoip php5-redis php5-memcache php5-memcached php5-mongo php5-xmlrpc php5-imagick
sudo apt-get install -y php5-xdebug

# Install Ruby & rake & rails
sudo apt-get install -y ruby-full rake rails ruby-dev ruby-compass

# Update gems
sudo gem update --system
sudo gem install sass
sudo gem install compass

# Install memcache
sudo pecl install memcache
sudo echo "extension=memcache.so" | sudo tee /etc/php5/conf.d/memcache.ini


# Install mysql and give password to installer
echo "--------------------------------------------------------";
echo "---- MySQL install & config";
echo "--------------------------------------------------------";
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install -y php5-mysql libapache2-mod-auth-mysql

# Install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# Setup hosts file
echo "--------------------------------------------------------";
echo "---- Apache config update";
echo "--------------------------------------------------------";
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite
sudo a2enmod rewrite

# Restart apache
sudo service apache2 restart

# Install git
echo "--------------------------------------------------------";
echo "---- Install extra DEV utils (git, composer...)";
echo "--------------------------------------------------------";
sudo apt-get -y install git

# Install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install phpunit via composer
sudo composer global require "phpunit/phpunit=4.1.*"
sudo composer global require "phpunit/php-invoker=~1.1."
sudo ln -s  ~/.composer/vendor/phpunit/phpunit/phpunit   /usr/bin/
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc
composer global require "squizlabs/php_codesniffer=*"
composer global require "phpmd/phpmd"

# Install nodejs & npm
echo "--------------------------------------------------------";
echo "---- Install NodeJS & NPM";
echo "--------------------------------------------------------";
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install nodejs and other npm modules
echo "--------------------------";
echo "---- NPM packages --------";
echo "--------------------------";
sudo npm install bower -g
sudo npm install --save gulp-install
sudo npm install -g yo
sudo npm install -g grunt-cli

# Setup Apache
echo "--------------------------------------------------------";
echo "---- Apache second config";
echo "--------------------------------------------------------";

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/short_open_tag = .*/short_open_tag = On/" /etc/php5/apache2/php.ini
sed -i "s/;opcache_enabled = .*/opcache_enabled = 0/" /etc/php5/apache2/php.ini
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Add xdebug conf
echo "--------------------------------------------------------";
echo "---- Update PHP for xDebug";
echo "--------------------------------------------------------";

echo "zend_extension=\"/usr/lib/php5/20100525/xdebug.so\"" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_enable=1" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_handler=dbgp" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_mode=req" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_host=127.0.0.1" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_port=9000" >> /etc/php5/apache2/php.ini
echo "xdebug.max_nesting_level=200" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_autostart=1" >> /etc/php5/apache2/php.ini
echo "xdebug.idekey = PHPSTORM" >> /etc/php5/apache2/php.ini
# Unlimited nesting for xdebug!
echo "xdebug.var_display_max_depth = -1" >> /etc/php5/apache2/php.ini
echo "xdebug.var_display_max_children = -1" >> /etc/php5/apache2/php.ini
echo "xdebug.var_display_max_data = -1" >> /etc/php5/apache2/php.ini

sudo service apache2 restart

# Add mailcatcher for email debugging
echo "--------------------------------------------------------";
echo "---- Install mailcatcher";
echo "--------------------------------------------------------";
sudo gem install mailcatcher
sudo echo "@reboot $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab
sudo update-rc.d cron defaults
sudo echo "sendmail_path = /usr/bin/env $(which catchmail)" >> /etc/php5/mods-available/mailcatcher.ini
sudo php5enmod mailcatcher
sudo /usr/bin/env $(which mailcatcher) --ip=0.0.0.0

sudo echo "description \"Mailcatcher\"" >> /etc/init/mailcatcher.conf
sudo echo "start on runlevel [2345]" >> /etc/init/mailcatcher.conf
sudo echo "stop on runlevel [!2345]" >> /etc/init/mailcatcher.conf
sudo echo "respawn" >> /etc/init/mailcatcher.conf
sudo echo "exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0" >> /etc/init/mailcatcher.conf
sudo service mailcatcher restart


echo "--------------------------------------------------------";
echo "---- Install Message Queue apps (rabbitmq, beanstalkd)";
echo "--------------------------------------------------------";
sudo apt-get install -y beanstalkd rabbitmq-server php-amqplib amqp-tools
sed -i 's/#START=yes/START=yes/' /etc/default/beanstalkd


# Restart apache
sudo service apache2 reload
sudo service apache2 restart



echo "--------------------------------------------------------";
echo "---- Install PHP 5.6 & auto upgrade everything";
echo "--------------------------------------------------------";
sudo add-apt-repository ppa:ondrej/php5-5.6 -y
sudo apt-get update
sudo apt-get upgrade -y
sudo aptitude full-upgrade -y

# Restart apache
sudo service apache2 reload
sudo service apache2 restart



echo "--------------------------------------------------------";
echo "---- Done";
echo "---- Box ip: 192.168.33.22";
echo "--------------------------------------------------------";
