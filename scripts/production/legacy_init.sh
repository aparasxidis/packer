#!/usr/bin/env bash

set -e

# Update the instance
sudo yum clean all && sudo yum -y update

# Install dos2unix
sudo yum install dos2unix -y

# Install telnet
sudo yum install telnet -y

# Install wget
sudo yum install wget -y

# Install git
sudo yum install git -y

# Install yum-cron
sudo yum install yum-cron -y
sudo sed -i '/update_cmd/s/= .*/= security/' /etc/yum/yum-cron-hourly.conf
sudo sed -i '/update_messages/s/= .*/= no/' /etc/yum/yum-cron-hourly.conf
sudo sed -i '/apply_updates/s/= .*/= yes/' /etc/yum/yum-cron-hourly.conf
sudo sed -i '/download_updates/s/= .*/= yes/' /etc/yum/yum-cron-hourly.conf
sudo sed -i '/download_updates/s/= .*/= no/' /etc/yum/yum-cron.conf
sudo service yum-cron start
sudo chkconfig yum-cron

# Setup the scripts
mv /tmp/*_script /usr/local/bin/
chown root:root /usr/local/bin/*_script
chmod +x /usr/local/bin/*_script

# Setup the scripts with dos2unix
sudo dos2unix /usr/local/bin/*_script

# Create cert directory to mount to ECS Docker containers
sudo mkdir /certs/
mv /tmp/us-east-1-bundle.pem /certs/
