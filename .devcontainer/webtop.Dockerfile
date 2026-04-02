FROM lscr.io/linuxserver/webtop:ubuntu-xfce

ENV DEBIAN_FRONTEND=noninteractive

# ============================================================
#  Layer 1: System packages (reliable, fast)
# ============================================================
RUN echo "[1/4] Installing system packages..." && \
    apt-get update && apt-get install -y --no-install-recommends \
    firefox \
    nmap masscan dnsutils whois dnsrecon dnsenum dirb gobuster \
    sqlmap nikto wfuzz \
    hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common socat proxychains4 \
    openvpn wireguard-tools \
    gdb binwalk ltrace strace radare2 \
    curl wget git unzip jq tmux zsh \
    python3 python3-pip python3-venv python3-dev \
    golang-go \
    xfce4-whiskermenu-plugin xfce4-goodies xfce4-terminal \
    sshfs ftp rlwrap tree file dos2unix xxd \
    && rm -rf /var/lib/apt/lists/* \
    && echo "[1/4] System packages done."

# ============================================================
#  Layer 2: Go tools (each isolated so one failure doesn't block)
# ============================================================
ENV GOPATH=/opt/go PATH="/opt/go/bin:/usr/local/go/bin:${PATH}"

RUN echo "[2/4] Installing Go tools..." && \
    go install github.com/ffuf/ffuf/v2@latest && echo "  [+] ffuf" && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && echo "  [+] httpx" && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && echo "  [+] subfinder" && \
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && echo "  [+] nuclei" && \
    go install github.com/tomnomnom/waybackurls@latest && echo "  [+] waybackurls" && \
    go install github.com/tomnomnom/gf@latest && echo "  [+] gf" && \
    go install github.com/lc/gau/v2/cmd/gau@latest && echo "  [+] gau" && \
    go install github.com/hakluke/hakrawler@latest && echo "  [+] hakrawler" ; \
    rm -rf /root/go/pkg /root/go/src /tmp/* 2>/dev/null ; \
    echo "[2/4] Go tools done. Installed: $(ls /opt/go/bin/ 2>/dev/null | wc -l) tools"

# ============================================================
#  Layer 3: Python tools
# ============================================================
RUN echo "[3/4] Installing Python tools..." && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir \
        impacket \
        pwntools \
        crackmapexec \
    && echo "  [+] Core Python tools installed" && \
    /opt/venv/bin/pip install --no-cache-dir \
        volatility3 \
        certipy-ad \
        bloodhound \
        git-dumper \
    && echo "  [+] Extra Python tools installed" ; \
    rm -rf /root/.cache 2>/dev/null ; \
    echo "[3/4] Python tools done."

ENV PATH="/opt/venv/bin:${PATH}"

# ============================================================
#  Layer 4: Wordlists & privesc
# ============================================================
RUN echo "[4/4] Downloading wordlists & privesc tools..." && \
    mkdir -p /opt/wordlists /opt/privesc /opt/tools && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git /opt/wordlists/SecLists && \
    echo "  [+] SecLists cloned" && \
    wget -q -P /opt/privesc \
      https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh \
      https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe \
      https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 && \
    chmod +x /opt/privesc/* && \
    echo "  [+] PrivEsc tools downloaded" && \
    echo "[4/4] Wordlists done."

# ============================================================
#  Config (lightweight, changes often)
# ============================================================
COPY scripts/  /opt/setup-scripts/
COPY config/   /opt/default-config/
RUN chmod +x /opt/setup-scripts/*.sh 2>/dev/null; true

EXPOSE 3000
