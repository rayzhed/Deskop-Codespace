#!/bin/bash
# 03-create-launchers.sh - XFCE desktop shortcuts

echo "[cyber] Creating desktop launchers..."

DIR="/usr/share/applications"
DESK="/config/Desktop"
mkdir -p "$DESK"

# Terminal
cat > "$DIR/cyber-terminal.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Cyber Terminal
Exec=xfce4-terminal --command=/bin/zsh
Icon=utilities-terminal
Categories=System;
EOF

# Firefox
cat > "$DIR/firefox-pentest.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Firefox
Exec=firefox
Icon=firefox
Categories=Network;
EOF

# Wordlists folder
cat > "$DIR/wordlists.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Wordlists
Exec=thunar /opt/wordlists
Icon=folder
Categories=Security;
EOF

# HTB init
cat > "$DIR/htb-new.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=New HTB Box
Exec=xfce4-terminal --command="bash -c 'source /config/.zshrc; echo Enter box name:; read n; htb-init \$n; exec zsh'"
Icon=folder-new
Categories=Security;
EOF

# Copy to desktop
for app in cyber-terminal firefox-pentest wordlists htb-new; do
    cp "$DIR/$app.desktop" "$DESK/" && chmod +x "$DESK/$app.desktop"
done 2>/dev/null

echo "[cyber] Launchers created."
