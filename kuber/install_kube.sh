#!/bin/bash

# Swap off jika Kubernetes dipasang di VM atau disk tradisional
#swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

# Konfigurasi modul untuk loading persisten
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# Load modul pada runtime
modprobe overlay
modprobe br_netfilter

# Update pengaturan iptables
cat <<EOF | tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Terapkan pengaturan kernel tanpa reboot
sysctl --system

# Menambahkan kunci GPG repo Docker ke trusted keys
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Menambahkan repository Docker ke sumber paket Ubuntu
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instal containerd
apt-get update && apt-get install -y containerd.io

# Konfigurasi containerd untuk manajemen cgroup sistem
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Reload daemon, restart, enable
systemctl daemon-reload
systemctl restart containerd
systemctl enable containerd

# Update indeks paket apt dan instal paket yang dibutuhkan untuk konfigurasi sertifikat https Kubernetes
apt-get update && apt-get install -y apt-transport-https ca-certificates curl

# Download kunci GPG Kubernetes dan simpan di /etc/apt/keyrings/
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Menambahkan repository Kubernetes ke sumber paket sistem
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Instal paket kubelet, kubeadm, dan kubectl
apt-get update && apt-get install -y kubelet kubeadm kubectl

# Hold versi paket yang terinstal agar tidak diupgrade
apt-mark hold kubelet kubeadm kubectl

# Mulai service kubelet di semua node
systemctl enable kubelet
