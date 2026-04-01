#!/bin/bash

echo "[INFO] Cleaning old VNC sessions..."

# Kill old VNC server if running
vncserver -kill :1 2>/dev/null || true

# Remove stale X11 locks
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* 2>/dev/null || true

echo "[INFO] Starting VNC server..."
touch ~/.Xauthority
vncserver -geometry 1920x1080 -depth 24 :1

echo "[INFO] Cleaning old noVNC/websockify..."
pkill websockify 2>/dev/null || true

echo "[INFO] Starting noVNC..."
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

echo "[INFO] VNC + noVNC started."
echo "[INFO] Open your browser at:"
echo "       https://<your-codespace>-6080.app.github.dev/vnc.html"
