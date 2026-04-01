#!/bin/bash

echo "[INFO] Starting Webtop XFCE container..."

docker rm -f webtop 2>/dev/null || true

docker run -d \
  --name webtop \
  -p 3000:3000 \
  --shm-size="2gb" \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ="Europe/Paris" \
  linuxserver/webtop:ubuntu-xfce

echo "[INFO] Webtop started!"
echo "[INFO] Open your browser at:"
echo "       https://<your-codespace>-3000.app.github.dev"
