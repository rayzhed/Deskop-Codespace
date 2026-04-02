#!/bin/bash

# bootstrap.sh - Runs ONCE at codespace creation (postCreateCommand)

IMAGE_NAME="webtop-cyber"

GHCR_IMAGE="${GHCR_IMAGE:-}"

echo ""

echo "=============================================="

echo "     Cyber Desktop - Building Image"

echo "=============================================="

echo ""

# Strategy 1: Pull prebuilt image from GHCR

if [ -n "$GHCR_IMAGE" ]; then

    echo "[*] Pulling prebuilt image: $GHCR_IMAGE"

    if docker pull "$GHCR_IMAGE" 2>&1; then

        docker tag "$GHCR_IMAGE" "$IMAGE_NAME"

        echo "[+] Image pulled successfully. Startup will be fast."

        exit 0

    fi

    echo "[!] Pull failed, building locally..."

    echo ""

fi

# Strategy 2: Build locally

echo "[*] Building image locally. This takes ~8-12 min on first run."

echo "[*] Progress will appear below..."

echo ""

docker build \

    --progress=plain \

    -t "$IMAGE_NAME" \

    -f .devcontainer/webtop.Dockerfile \

    .devcontainer/ 2>&1

BUILD_EXIT=$?

if [ $BUILD_EXIT -ne 0 ]; then

    echo ""

    echo "[ERROR] Docker build failed with exit code $BUILD_EXIT"

    echo "[ERROR] Check the logs above for details."

    echo "[ERROR] Common fixes:"

    echo "  - A Go tool may have changed its import path"

    echo "  - A Python package may have a broken release"

    echo "  - Network timeout (just retry: rebuild the codespace)"

    exit 1

fi

echo ""

echo "[+] Image built successfully!"

echo "[+] Image size: $(docker image inspect "$IMAGE_NAME" --format='{{.Size}}' | numfmt --to=iec 2>/dev/null || echo 'unknown')"