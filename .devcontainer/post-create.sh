#!/bin/bash
set -e

# Prevent ALL interactive prompts (keyboard, timezone, wireshark, etc.)
export DEBIAN_FRONTEND=noninteractive

# Preseed Wireshark to avoid the yes/no prompt
echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections

# Fix Yarn repo
sudo rm -f /etc/apt/sources.list.d/yarn.list
sudo rm -f /etc/apt/sources.list.d/*yarn*

# Update system
sudo apt-get update -yq
sudo apt-get upgrade -yq

# Desktop + VNC
sudo apt-get install -yq --no-install-recommends \
    xfce4 xfce4-goodies tigervnc-standalone-server dbus-x11 \
    novnc websockify falkon xterm git

# Pentest tools
sudo apt-get install -yq --no-install-recommends \
    nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common dirb dnsutils whois \
    openvpn ssh curl wget python3 python3-pip

# Optional: SecLists (avoid 3GB)
# git clone https://github.com/danielmiessler/SecLists.git ~/SecLists

# VNC config
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Create VNC password if missing
if [ ! -f ~/.vnc/passwd ]; then
    echo "pentest" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
fi

# Clean old sessions
vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true

# Reduce Codespace size
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
