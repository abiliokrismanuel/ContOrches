# backup
docker run --rm \
  -v prometheus-data:/data \
  -v /path/to/backup:/backup \
  busybox \
  sh -c "cd /data && tar czf /backup/prometheus-backup-$(date +%Y-%m-%d).tar.gz ."


# restore
docker run --rm \
  -v prometheus-data:/data \
  -v ./prometheus:/backup \
  busybox \
  sh -c "cd /data && tar xzf /backup/prometheus-data-2024-11-25.tar.gz"

