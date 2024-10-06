#!/bin/bash

# Set etcd version
ETCD_VER=v3.5.16

# Set the node name and IPs
ETCD_NAME_1=kubernetes-master-1
ETCD_NAME_2=kubernetes-master-2
ETCD_NAME_3=kubernetes-master-3
NODE1_IP= <priv-ip-1>
NODE2_IP= <priv-ip-2>
NODE3_IP= <priv-ip-3>

# Set download URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

# Remove old files if they exist
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

# Download the specified version of etcd
echo "Downloading etcd ${ETCD_VER}..."
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

# Extract the downloaded tarball
echo "Extracting etcd package..."
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1

# Remove the tarball
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

# Move the binaries to /usr/local/bin
echo "Installing etcd binaries..."
sudo cp /tmp/etcd-download-test/etcd* /usr/local/bin

# Create the environment file for etcd
echo "Creating etcd environment file..."
sudo tee /etc/default/etcd > /dev/null <<EOL
# /etc/default/etcd

# Configuration for etcd node 1-3 in HA setup
ETCD_NAME=${ETCD_NAME_3}
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://${NODE3_IP}:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://${NODE3_IP}:2379"
ETCD_INITIAL_CLUSTER="${ETCD_NAME_1}=http://${NODE1_IP}:2380,${ETCD_NAME_2}=http://${NODE2_IP}:2380,${ETCD_NAME_3}=http://${NODE3_IP}:2380"
#ETCD_INITIAL_CLUSTER_STATE="existing"
#ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
#ETCD_AUTO_COMPACTION_RETENTION="1"
EOL

# Create systemd service file for etcd
echo "Creating systemd service file for etcd..."
sudo tee /etc/systemd/system/etcd.service > /dev/null <<EOL
[Unit]
Description=etcd
Documentation=https://github.com/etcd-io/etcd

[Service]
Type=notify
EnvironmentFile=/etc/default/etcd
ExecStart=/usr/local/bin/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd daemon to apply the new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable and start etcd service
echo "Enabling and starting etcd service..."
sudo systemctl enable etcd
sudo systemctl start etcd

# Check the status of etcd service
echo "Checking etcd service status..."
sudo systemctl status etcd

# Check etcd version to verify installation
echo "Installation completed. etcd version:"
etcd --version

#cek status
#etcdctl --endpoints=http://${NODE1_IP}:2379,http://http://${NODE2_IP}:2379,http://${NODE1_IP}:2379 endpoint status --write-out=table
