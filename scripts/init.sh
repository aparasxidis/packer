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

# Setup the scripts
mv /tmp/*_script /usr/local/bin/
chown root:root /usr/local/bin/*_script
chmod +x /usr/local/bin/*_script

# Setup the scripts with dos2unix
sudo dos2unix /usr/local/bin/*_script

# Create cert directory to mount to ECS Docker containers
sudo mkdir /certs/
mv /tmp/us-east-1-bundle.pem /certs/

## Run CIS scripts
sudo mkdir /cis-scripts/
mv /tmp/CIS-LBK.tar.gz /cis-scripts/
sudo tar -xzvf /cis-scripts/CIS-LBK.tar.gz
#sudo yes | /cis-scripts/CIS-LBK/RHEL7_LBK/RHEL7_LBK.sh
