#!/bin/bash

set -e

# bootstrap.sh - Runs ONCE at codespace creation (postCreateCommand)

IMAGE_NAME="webtop-cyber"

# Allow manual override via GHCR_IMAGE.
if [ -z "$GHCR_IMAGE" ]; then
  resolve_repo() {
    if [ -n "$GITHUB_REPOSITORY" ]; then
      echo "$GITHUB_REPOSITORY"
      return 0
    fi

    if [ -n "$GITHUB_REPOSITORY_OWNER" ] && [ -n "$GITHUB_REPOSITORY_NAME" ]; then
      echo "${GITHUB_REPOSITORY_OWNER}/${GITHUB_REPOSITORY_NAME}"
      return 0
    fi

    if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      repo_url=$(git config --get remote.origin.url || true)
      repo_url=${repo_url%.git}

      case "$repo_url" in
        git@github.com:*)
          echo "${repo_url#git@github.com:}"
          return 0
          ;;
        https://github.com/*)
          echo "${repo_url#https://github.com/}"
          return 0
          ;;
        ssh://git@github.com/*)
          echo "${repo_url#ssh://git@github.com/}"
          return 0
          ;;
      esac
    fi

    return 1
  }

  if repo_spec=$(resolve_repo); then
    GITHUB_USER="${GITHUB_REPOSITORY_OWNER:-$(echo "$repo_spec" | cut -d'/' -f1)}"
    REPO_NAME="$(echo "$repo_spec" | cut -d'/' -f2)"
    GHCR_IMAGE="ghcr.io/${GITHUB_USER}/${REPO_NAME}/webtop-cyber:latest"
  fi
fi

echo ""
echo "=============================================="
echo "     Cyber Desktop - Setting Up"
echo "=============================================="

if [ -n "$GHCR_IMAGE" ]; then
  echo "  Pulling: $GHCR_IMAGE"
  echo "=============================================="
  echo ""

  if docker pull "$GHCR_IMAGE" 2>&1; then
    docker tag "$GHCR_IMAGE" "$IMAGE_NAME"
    echo ""
    echo "[+] Image ready."
    exit 0
  fi

  login_token="${GITHUB_TOKEN:-${GH_TOKEN:-${GHCR_PAT:-${CR_PAT:-}}}}"
  login_user="${GITHUB_ACTOR:-${GITHUB_USER:-$(whoami)}}"

  if [ -n "$login_token" ] && [ -n "$login_user" ]; then
    echo "[*] Pull failed; attempting GHCR login and retry..."
    echo "$login_token" | docker login ghcr.io -u "$login_user" --password-stdin >/dev/null 2>&1 || true

    if docker pull "$GHCR_IMAGE" 2>&1; then
      docker tag "$GHCR_IMAGE" "$IMAGE_NAME"
      echo ""
      echo "[+] Image ready after GHCR login."
      exit 0
    fi
  fi

  echo ""
  echo "[!] Pull failed, building locally (~10min)..."
  echo ""
else
  echo "[*] No GHCR image configured or detected. Building locally..."
  echo ""
fi

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
echo "[+] Build complete."
