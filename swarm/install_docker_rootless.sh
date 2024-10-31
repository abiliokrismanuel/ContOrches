#!/bin/bash

# jalankan chmod +x <file.sh> nya dahulu

# Langkah 1: Install paket yang memungkinkan apt menggunakan paket melalui HTTPS
echo "Menginstall paket yang diperlukan..."
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Langkah 2: Tambahkan kunci GPG untuk repo resmi Docker
echo "Menambahkan kunci GPG resmi Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc

# Langkah 3: Tambahkan repo Docker ke sumber apt
echo "Menambahkan repository Docker..."
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"

# Langkah 4: Install Docker
echo "Menginstall Docker..."
sudo apt update
sudo apt install docker-ce -y

# Langkah 5: Install Docker Rootless dependencies
echo "Menginstall dependencies Docker Rootless..."
sudo apt install -y dbus-user-session uidmap

# Langkah 6: Install Docker Compose versi 2.29.2
echo "Menginstall Docker Compose versi 2.29.2..."
sudo curl -L "https://github.com/docker/compose/releases/download/2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Langkah 7: Verifikasi instalasi Docker Compose
echo "Memverifikasi instalasi Docker Compose..."
docker-compose --version

# Langkah 8: dep EFS aws
sudo apt install nfs-common -y
sudo mkdir -p /home/ubuntu/swarm/efs-docker

# Langkah 9: Memastikan Memory Overcommit diaktifkan (redis warning fix)
echo "Mengaktifkan memory overcommit..."
sudo sysctl -w vm.overcommit_memory=1
sudo sh -c 'echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf'
sudo sysctl -p

# Langkah 10: Install Docker Rootless
echo "Menginstall Docker Rootless..."
dockerd-rootless-setuptool.sh install

# Langkah 11: Set environment variables untuk Docker Rootless
echo "Menambahkan environment variables untuk Docker Rootless ke .bashrc..."
echo 'export PATH=/usr/bin:$PATH' >> ~/.bashrc
echo 'export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock' >> ~/.bashrc
source ~/.bashrc

# Langkah 12: Verifikasi Docker Rootless
echo "Memverifikasi Docker Rootless..."
docker context use rootless
docker info

# Langkah 13 (Opsional): Izinkan user saat ini menjalankan perintah Docker tanpa sudo
echo "Menambahkan user saat ini ke grup Docker..."
sudo usermod -aG docker ${USER}

# Terapkan grup baru tanpa perlu logout dan login kembali
newgrp docker

echo "Instalasi selesai."
