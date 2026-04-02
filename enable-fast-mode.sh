#!/bin/bash
# enable-fast-mode.sh
# Optional helper for overriding the GHCR image path.
# The bootstrap script now auto-detects the repository and pulls the correct GHCR image.
#
# Usage:
#   1. Push the repo to GitHub
#   2. Go to Actions tab → "Build Cyber Desktop Image" → Run workflow
#   3. Wait for it to complete (~10min)
#   4. Run: bash enable-fast-mode.sh <your-github-username> <repo-name>
#   5. Commit and push
#   6. Next codespace launch: ~30s

set -e

GITHUB_USER="${1:?Usage: $0 <github-username> <repo-name>}"
REPO_NAME="${2:?Usage: $0 <github-username> <repo-name>}"

IMAGE="ghcr.io/${GITHUB_USER}/${REPO_NAME}/webtop-cyber:latest"

echo "[*] Configuring fast mode with image: $IMAGE"

# Update bootstrap.sh
sed -i "s|^GHCR_IMAGE=.*|GHCR_IMAGE=\"${IMAGE}\"|" .devcontainer/bootstrap.sh

echo "[+] Done! Commit and push .devcontainer/bootstrap.sh"
echo "[+] Next codespace will pull the prebuilt image (~30s startup)"
