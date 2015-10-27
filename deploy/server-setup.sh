#!/bin/bash

echo "packer: updating aptitude"
sudo apt-key update
sudo apt-get update
sudo apt-get remove apt-listchanges -y
sudo add-apt-repository ppa:nginx/stable -y

echo "packer: nginx - base install"
sudo mkdir -p /var/log/nginx
sudo chown $INSTANCE_USER /var/log/nginx
sudo chmod -R 755 /var/log/nginx
sudo apt-get install nginx -y

echo "packer: nginx - installing as a service"
sudo update-rc.d nginx defaults

echo "packer: nginx - Installing config"
sudo mkdir -p /etc/nginx/
sudo mv /tmp/nginx.conf /etc/nginx/sites-enabled
#sudo chown $INSTANCE_USER /etc/nginx/
#sudo chmod -r 755 /etc/nginx/

echo "packer: nginx - Install SSL Certificate"
sudo mkdir -p /etc/ssl/
sudo mv /tmp/domain.key /etc/ssl/
sudo mv /tmp/domain.pem /etc/ssl/
#sudo chown $INSTANCE_USER /etc/ssl/
#sudo chmod -r 755 /etc/ssl/

echo "packer: reload nginx"
sudo service nginx reload
