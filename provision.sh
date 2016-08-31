#! /usr/bin/env bash

PACKAGES='sudo curl git htop vim unzip software-properties-common build-essential dos2unix gcc git libmcrypt4 libpcre3-dev make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim libnotify-bin php7.0-cli php7.0-dev php-sqlite3 php-gd php-imagick php-apcu php-curl php7.0-mcrypt php-imap  php-mysql php-memcached php7.0-readline php-mbstring php-xml php7.0-zip php7.0-intl php7.0-bcmath php-soap nginx php7.0-fpm mariadb-server-10.0 redis-server memcached beanstalkd npm nodejs-legacy letsencrypt'

export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server-10.0 mysql-server/root_password password root" | debconf-set-selections
echo "mariadb-server-10.0 mysql-server/root_password_again password root" | debconf-set-selections

#Upgrading
apt-get update
apt-get upgrade -y

# Install packages
apt-get install -y $PACKAGES

#Install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer  

#Install gulp
npm install -g gulp

#Creating deploy user
adduser deploy --disabled-password --gecos ""
adduser deploy sudo
echo "deploy:password" | chpasswd 
passwd -e deploy
mkdir /home/deploy/.ssh 
cp /root/.ssh/authorized_keys /home/deploy/.ssh/ 
chmod 600 /home/deploy/.ssh/authorized_keys 
chown -R deploy:deploy /home/deploy/.ssh 
chmod 700 /home/deploy/.ssh 
usermod -aG deploy www-data

#Create a beta user for beta.app.com with sudo powers but no password (set it if you need to use the account)
adduser beta --disabled-password --gecos ""
adduser beta sudo
mkdir /home/beta/.ssh 
cp /root/.ssh/authorized_keys /home/beta/.ssh/ 
chmod 600 /home/beta/.ssh/authorized_keys 
chown -R beta:beta /home/beta/.ssh 
chmod 700 /home/beta/.ssh 
usermod -aG beta www-data

#Enable Swap
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k &>> /var/log/do-debian-setup.txt 
sudo mkswap /swapfile &>> /var/log/do-debian-setup.txt 
sudo swapon /swapfile
echo "/swapfile   none  swap  sw  0   0" >> /etc/fstab 
echo 10 > /proc/sys/vm/swappiness 
echo "vm.swappiness = 10" >> /etc/sysctl.conf 
chown root:root /swapfile 
chmod 0600 /swapfile 

#Block ssh connections
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config 
service ssh reload &>> /var/log/do-debian-setup.txt