#!/bin/bash

# Variabel
MOUNT_POINT="/home/ubuntu/swarm/efs-docker"
SERVICE_FILE="/etc/systemd/system/mount-efs.service"

# Cek apakah direktori mount-point sudah ada, buat jika belum
if [ ! -d "$MOUNT_POINT" ]; then
  echo "Membuat direktori mount point di $MOUNT_POINT"
  mkdir -p "$MOUNT_POINT"
fi

# Melakukan mount EFS
echo "Melakukan mount EFS $EFS_DNS ke $MOUNT_POINT"
sudo mount <endpoint>:/ "$MOUNT_POINT"

# Cek apakah mount berhasil
if mountpoint -q "$MOUNT_POINT"; then
  echo "EFS berhasil di-mount."
else
  echo "Gagal melakukan mount EFS."
fi

# Membuat konfigurasi Systemd untuk mounting EFS secara otomatis
echo "Membuat file service Systemd di $SERVICE_FILE"

cat <<EOF | sudo tee $SERVICE_FILE
[Unit]
Description=Mount Amazon EFS secara otomatis
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash /home/ubuntu/mount-efs.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Reload Systemd dan enable service
echo "Mengaktifkan service Systemd untuk mounting otomatis"
sudo systemctl daemon-reload
sudo systemctl enable mount-efs.service
