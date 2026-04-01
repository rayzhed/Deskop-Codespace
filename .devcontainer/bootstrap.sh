#!/bin/bash
set -e

echo "[BOOTSTRAP] Installing Docker dependencies..."
sudo apt-get update -y
sudo apt-get install -y docker.io

sudo usermod -aG docker vscode
