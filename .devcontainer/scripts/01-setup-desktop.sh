#!/bin/bash
# 01-setup-desktop.sh - Runs inside webtop via /custom-cont-init.d/

echo "[cyber] Configuring desktop environment..."

# --- Theme ---
su -c 'xfconf-query -c xsettings -p /Net/ThemeName -s "Greybird-dark" --create -t string' abc 2>/dev/null || true
su -c 'xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" --create -t string' abc 2>/dev/null || true

# --- Terminal colors ---
mkdir -p /config/.config/xfce4/terminal
cat > /config/.config/xfce4/terminal/terminalrc << 'EOF'
[Configuration]
BackgroundMode=TERMINAL_BACKGROUND_TRANSPARENT
BackgroundDarkness=0.85
ColorForeground=#00ff00
ColorBackground=#0a0a0a
ColorPalette=#000000;#cc0000;#4e9a06;#c4a000;#3465a4;#75507b;#06989a;#d3d7cf;#555753;#ef2929;#8ae234;#fce94f;#729fcf;#ad7fa8;#34e2e2;#eeeeec
FontName=Monospace 11
ScrollingLines=10000
MiscAlwaysShowTabs=FALSE
EOF

# --- Dark wallpaper ---
su -c 'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -s "" --create -t string' abc 2>/dev/null || true

# --- Tmux config ---
cp /opt/default-config/.tmux.conf /config/.tmux.conf 2>/dev/null || true

# --- Proxychains ---
cp /opt/default-config/proxychains.conf /etc/proxychains4.conf 2>/dev/null || true

echo "[cyber] Desktop setup done."
