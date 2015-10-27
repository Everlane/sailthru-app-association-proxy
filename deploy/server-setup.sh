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
