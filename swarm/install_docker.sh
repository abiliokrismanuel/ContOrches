#!/bin/bash

# jalankan chmod +x <file.sh> nya dahulu

# Langkah 1: Install paket yang memungkinkan apt menggunakan paket melalui HTTPS
echo "Menginstall paket yang diperlukan..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Langkah 2: Tambahkan kunci GPG untuk repo resmi Docker
echo "Menambahkan kunci GPG resmi Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Langkah 3: Tambahkan repo Docker ke sumber apt
echo "Menambahkan repository Docker..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"

# Langkah 4: Install Docker
echo "Menginstall Docker..."
sudo apt update
sudo apt install -y docker-ce

# Langkah 5 (Opsional): Izinkan user saat ini menjalankan perintah Docker tanpa sudo
echo "Menambahkan user saat ini ke grup Docker..."
sudo usermod -aG docker ${USER}

# Terapkan grup baru tanpa perlu logout dan login kembali
newgrp docker

# Langkah 6: Install Docker Compose versi 2.29.2
echo "Menginstall Docker Compose versi 2.29.2..."
sudo curl -L "https://github.com/docker/compose/releases/download/2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Langkah 7: Verifikasi instalasi Docker Compose
echo "Memverifikasi instalasi Docker Compose..."
docker-compose --version

echo "Instalasi selesai."
