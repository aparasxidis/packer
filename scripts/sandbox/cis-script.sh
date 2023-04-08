#!/usr/bin/env bash

set -e

### Run CIS scripts
sudo mkdir /cis-scripts/
mv /tmp/CIS-LBK.tar.gz /cis-scripts/
sudo tar -xzvf /cis-scripts/CIS-LBK.tar.gz -C /cis-scripts/
chmod +x /cis-scripts/CIS-LBK/RHEL7_LBK/RHEL7_LBK.sh
sudo yes | /cis-scripts/CIS-LBK/RHEL7_LBK/RHEL7_LBK.sh
