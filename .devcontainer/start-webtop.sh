#!/bin/bash

echo "[INFO] Starting Webtop XFCE container..."

# Stop old container
docker rm -f webtop 2>/dev/null || true

# Build custom image
docker build -t webtop-custom -f .devcontainer/webtop.Dockerfile .

# Run Webtop
docker run -d \
  --name webtop \
  -p 3000:3000 \
  --shm-size="2gb" \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ="Europe/Paris" \
  webtop-custom

echo "[INFO] Webtop started!"
echo "[INFO] Opening browser shortly..."
sleep 2
echo "[INFO] If not opened automatically:"
echo "       https://<your-codespace>-3000.app.github.dev"
