#!/bin/bash
set -e

# -----------------------------
# Real-time logging
# -----------------------------
LOGFILE="$HOME/post-create.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "[INFO] Logging to $LOGFILE"
echo "[INFO] Starting post-create script..."

# Prevent ALL interactive prompts
export DEBIAN_FRONTEND=noninteractive

echo "[STEP] Cleaning Yarn repo..."
sudo rm -f /etc/apt/sources.list.d/yarn.list
sudo rm -f /etc/apt/sources.list.d/*yarn*

echo "[STEP] Updating system..."
sudo apt-get update -yq
sudo apt-get upgrade -yq

echo "[STEP] Installing XFCE desktop + VNC..."
sudo apt-get install -yq --no-install-recommends \
    xfce4 xfce4-goodies tigervnc-standalone-server dbus-x11 \
    novnc websockify falkon xterm git

echo "[STEP] Installing pentest tools..."
sudo apt-get install -yq --no-install-recommends \
    nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common dirb dnsutils whois \
    openvpn ssh curl wget python3 python3-pip

# Optional: SecLists (avoid 3GB)
# git clone https://github.com/danielmiessler/SecLists.git ~/SecLists

echo "[STEP] Configuring VNC..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

if [ ! -f ~/.vnc/passwd ]; then
    echo "pentest" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
fi

echo "[STEP] Cleaning old VNC sessions..."
vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true

echo "[STEP] Cleaning APT cache..."
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

echo "[DONE] Post-create script completed successfully!"
