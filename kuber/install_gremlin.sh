#!/bin/bash

# Update package list dan install required packages
sudo apt update && sudo apt install -y apt-transport-https dirmngr

# Add Gremlin repository
echo "deb https://deb.gremlin.com/ release non-free" | sudo tee /etc/apt/sources.list.d/gremlin.list

# Import Gremlin GPG key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9CDB294B29A5B1E2E00C24C022E8EF3461A50EF6

# Install Gremlin
sudo apt update && sudo apt install -y gremlin gremlind

# GREMLIN_INSTALL_USER=root GREMLIN_INSTALL_GROUP=root GREMLIN_INSTALL_BIN_MODE=0770 \
#   sudo -E apt install -y gremlin gremlind

# Ubah permissions containerd socket
#sudo chown root:gremlin /run/containerd/containerd.sock
#sudo chmod 660 /run/containerd/containerd.sock

# Buat the Gremlin configuration file
GREMLIN_CONFIG="/etc/gremlin/config.yaml"
sudo tee "$GREMLIN_CONFIG" > /dev/null <<EOL
##
## The Gremlin Configuration File
##
## Populating the values below is the preferred way to configure Gremlin installations directly on the host.
##
## More info at https://www.gremlin.com/docs/infrastructure-layer/advanced-configuration/
##
## Uncomment and edit the lines below to pass them to Gremlin.
##

## Gremlin Identifier; uniquely identifies this agent with Gremlin
## (can also set with GREMLIN_IDENTIFIER environment variable)
#identifier: gremlin-01

## Gremlin Team Id; you can find this value at https://app.gremlin.com/settings/teams
## (can also be set with GREMLIN_TEAM_ID environment variable)
team_id: 28ecd994-5bc8-4d42-acd9-945bc87d42bb

## Gremlin Client Tags; Tag your agent with key-value pairs that help you target this agent during attacks
## (can also set with GREMLIN_CLIENT_TAGS environment variable)
#tags:
#  service: pet-store
#  interface: http

## (can also set with GREMLIN_TEAM_SECRET environment variable)
#team_secret: 11111111-1111-1111-1111-111111111111

## (can also set with GREMLIN_TEAM_CERTIFICATE_OR_FILE environment variable)
team_certificate: | 
 -----BEGIN CERTIFICATE-----
 <cert>
 -----END CERTIFICATE-----
 


## (can also set with GREMLIN_TEAM_PRIVATE_KEY_OR_FILE environment variable)
team_private_key: | 
 -----BEGIN EC PRIVATE KEY-----
<cert>
 -----END EC PRIVATE KEY-----
 

## HTTPS Proxy, set this when routing outbound Gremlin HTTPS traffic through a proxy
## (can also set with HTTPS_PROXY or https_proxy environment variables)
#https_proxy: https://localhost:3128

## SSL CERT FILE, set this when using a https proxy with a self-signed certificate
## (can also set with SSL_CERT_FILE environment variable)
#ssl_cert_file: file:///var/lib/gremlin/proxy_cert.pem

## Push Metrics, tell Gremlin whether to send system metrics to the control plane for charting the impact of attacks in
## real time. Metrics are only collected during active attacks, and only metrics relevant to the attack are collected.
## (can also set with PUSH_METRICS environment variable)
#push_metrics: true

## Collect Process Data, data about running processes is sent to Gremlin for service discovery.
#collect_processes: false

## Collect DNS Data, data about network-bound dependencies is sent to Gremlin for service discovery.
#collect_dns: true
EOL

# Restart gremlind to apply the new configuration
sudo systemctl restart gremlind

echo "Gremlin installation completed, configuration file created, and gremlind restarted."
