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

# Installing Docker & Docker-compose
sudo yum -y install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose -v

# Setup the scripts
mv /tmp/*_script /usr/local/bin/
chown root:root /usr/local/bin/*_script
chmod +x /usr/local/bin/*_script

# Setup the scripts with dos2unix
sudo dos2unix /usr/local/bin/*_script

# Create AML directory to mount configuration files
sudo mkdir /home/ec2-user/aml
sudo mkdir /home/ec2-user/aml/mssql
mv /tmp/docker-compose.yml /home/ec2-user/aml
mv /tmp/mssql.conf /home/ec2-user/aml/mssql

# Preparing the EBS for mounting
sudo mkdir /mssql_data
