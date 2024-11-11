#!/bin/bash

# Tentukan versi Pumba
PUMBA_VERSION="0.10.1"
PUMBA_BINARY="pumba_linux_amd64"
DOWNLOAD_URL="https://github.com/alexei-led/pumba/releases/download/${PUMBA_VERSION}/${PUMBA_BINARY}"

# Unduh Pumba
echo "Mengunduh Pumba versi ${PUMBA_VERSION}..."
curl -L -o ${PUMBA_BINARY} ${DOWNLOAD_URL}

# Beri izin executable
chmod +x ${PUMBA_BINARY}

# Pindahkan ke /usr/local/bin agar bisa diakses dari mana saja
sudo mv ${PUMBA_BINARY} /usr/local/bin/pumba

# Verifikasi instalasi
echo "Verifikasi instalasi Pumba..."
if pumba --help > /dev/null 2>&1; then
    echo "Pumba berhasil diinstal."
else
    echo "Instalasi Pumba gagal."
fi
