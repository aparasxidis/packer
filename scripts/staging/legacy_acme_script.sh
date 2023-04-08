#!/bin/bash

set -euo pipefail

# Variables
DNSimple_OAUTH_TOKEN="5TgISkitJRHCak9LRsLqa0yRvZ74p8vG"

# Install acme.sh and configure a new path directory for certs
#cd /tmp/ && 
git clone https://github.com/acmesh-official/acme.sh.git
cd acme.sh/
./acme.sh --install  \
--cert-home /certs/ \
--accountemail "david.madrigal@arcusfi.com"

export DNSimple_OAUTH_TOKEN=$DNSimple_OAUTH_TOKEN

### Issue certs for the first time
./acme.sh --issue -d staging-legacy-apps.arcusfi.com --dns dns_dnsimple
