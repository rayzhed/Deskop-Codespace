#!/bin/bash

echo "[INFO] Starting VNC server..."

vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true

vncserver :1

echo "[INFO] Starting noVNC..."
pkill websockify 2>/dev/null || true
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

echo "[INFO] VNC + noVNC started."
