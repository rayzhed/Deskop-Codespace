#!/bin/bash
# start-webtop.sh - Runs on EVERY codespace attach (postAttachCommand)
# Image is already built/pulled by bootstrap.sh so this is fast

# ===================== CONFIG =====================
TIMEZONE="Europe/Paris"
KEYBOARD="fr"
# ==================================================

IMAGE_NAME="webtop-cyber"

echo "[*] Starting Cyber Desktop..."

# Reuse running container if it exists and is healthy
if docker ps --format '{{.Names}}' | grep -q '^webtop$'; then
    echo "[+] Webtop already running!"
else
    # Clean up stopped container
    docker rm -f webtop 2>/dev/null || true

    # Check image exists (should be built by bootstrap.sh)
    if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
        echo "[!] Image not found, building now..."
        docker build -t "$IMAGE_NAME" -f .devcontainer/webtop.Dockerfile .devcontainer/
    fi

    # Launch container
    docker run -d \
      --name webtop \
      -p 3000:3000 \
      --shm-size="2gb" \
      -e PUID=$(id -u) \
      -e PGID=$(id -g) \
      -e TZ="${TIMEZONE}" \
      -e KEYBOARD="${KEYBOARD}" \
      -v "$(pwd)/.devcontainer/scripts:/custom-cont-init.d:ro" \
      -v "$(pwd)/.devcontainer/config:/opt/default-config:ro" \
      --cap-add=NET_ADMIN \
      "$IMAGE_NAME"
fi

# Wait for VNC to be reachable (usually 5-15s)
echo "[*] Waiting for desktop..."
for i in $(seq 1 20); do
    if curl -s -o /dev/null http://localhost:3000 2>/dev/null; then
        echo ""
        echo "=============================================="
        echo "   CYBER DESKTOP READY"
        echo "=============================================="
        echo ""
        echo "   Tools:  nmap ffuf nuclei subfinder httpx"
        echo "           impacket crackmapexec certipy"
        echo "           john hashcat hydra pwntools"
        echo ""
        echo "   Dirs:   /opt/wordlists/SecLists"
        echo "           /opt/privesc  /opt/tools"
        echo ""
        echo "   Shell:  htb-init | ctf-init | bb-init"
        echo "=============================================="
        exit 0
    fi
    printf "."
    sleep 2
done

echo ""
echo "[!] Desktop may still be loading. Check port 3000."
