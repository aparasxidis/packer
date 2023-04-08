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
#sudo mkdir /certs/sies
#sudo mkdir /certs/sies/app01
#sudo mkdir /certs/sies/app02
mv /tmp/us-east-1-bundle.pem /certs/
#mv /tmp/prod-app01-sies_mxinfra_arcusfi_com.pem /certs/sies/app01
#mv /tmp/SectigoRSADomainValidationSecureServerCA.pem /certs/sies/app01
#mv /tmp/USERTrustRSAAAACA.pem /certs/sies/app01
#mv /tmp/AAACertificateServices.pem /certs/sies/app01
#mv /tmp/prod-app02-sies_mxinfra_arcusfi_com.pem /certs/sies/app02


# Install Sumologic Docker logging plugin
#docker plugin install store/sumologic/docker-logging-driver:1.0.4 --alias sumologic --grant-all-permissions

## Run CIS scripts
sudo mkdir /cis-scripts/
mv /tmp/CIS-LBK.tar.gz /cis-scripts/
sudo tar -xzvf /cis-scripts/CIS-LBK.tar.gz
sudo cd /cis-scripts/CIS-LBK/RHEL7_LBK/
sudo yes | ./RHEL7_LBK.sh

