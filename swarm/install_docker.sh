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
# echo "Mengaktifkan memory overcommit..."
# sudo sysctl -w vm.overcommit_memory=1
# sudo sh -c 'echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf'
# sudo sysctl -p

# Langkah 5 (Opsional): Izinkan user saat ini menjalankan perintah Docker tanpa sudo
echo "Menambahkan user saat ini ke grup Docker..."
sudo usermod -aG docker ${USER}

# Terapkan grup baru tanpa perlu logout dan login kembali
newgrp docker

echo "Instalasi selesai."
