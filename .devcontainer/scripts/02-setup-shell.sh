#!/bin/bash
# 02-setup-shell.sh - ZSH with pentest aliases

echo "[cyber] Setting up shell..."

# oh-my-zsh
su -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' abc 2>/dev/null || true

cat > /config/.zshrc << 'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git sudo command-not-found)
[ -f "$ZSH/oh-my-zsh.sh" ] && source $ZSH/oh-my-zsh.sh

export PATH="/opt/venv/bin:/opt/go/bin:$PATH"
export GOPATH="/opt/go"

# ---- Workspace generators ----
htb-init()  { local n="${1:?name?}"; mkdir -p ~/htb/$n/{nmap,loot,exploit,www}; cd ~/htb/$n; echo "# $n" > notes.md; echo "[+] ~/htb/$n ready"; }
ctf-init()  { local n="${1:?name?}"; mkdir -p ~/ctf/$n/{web,crypto,pwn,rev,forensics,misc,osint}; cd ~/ctf/$n; echo "[+] ~/ctf/$n ready"; }
bb-init()   { local n="${1:?name?}"; mkdir -p ~/bugbounty/$n/{recon,vulns,screenshots,reports}; cd ~/bugbounty/$n; echo "# $n" > scope.md; echo "[+] ~/bugbounty/$n ready"; }

# ---- Nmap ----
alias nmapq='nmap -sC -sV -oA scan_quick'
alias nmapf='nmap -sC -sV -p- -oA scan_full'
alias nmapu='sudo nmap -sU --top-ports 50 -oA scan_udp'
alias nmapv='nmap --script vuln -oA scan_vuln'
alias nse='ls /usr/share/nmap/scripts/ | grep'

# ---- Web fuzzing ----
alias ffuf-dir='ffuf -w /opt/wordlists/SecLists/Discovery/Web-Content/raft-medium-directories.txt -u'
alias ffuf-files='ffuf -w /opt/wordlists/SecLists/Discovery/Web-Content/raft-medium-files.txt -u'
alias ffuf-vhost='ffuf -w /opt/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -H "Host: FUZZ.TARGET" -u'

# ---- Impacket ----
alias psexec='impacket-psexec'
alias smbexec='impacket-smbexec'
alias wmiexec='impacket-wmiexec'
alias secretsdump='impacket-secretsdump'
alias getTGT='impacket-getTGT'
alias getNPUsers='impacket-GetNPUsers'
alias smbclient-ip='impacket-smbclient'

# ---- Quick ----
alias serve='python3 -m http.server 8888'
alias lnc='rlwrap nc -lvnp'
alias myip='curl -s ifconfig.me && echo'
alias wl='ls /opt/wordlists/SecLists/'
alias privesc='ls /opt/privesc/'

echo "  ╔═════════════════════════════════════╗"
echo "  ║    CYBER OFFENSIVE DESKTOP          ║"
echo "  ║  htb-init · ctf-init · bb-init      ║"
echo "  ╚═════════════════════════════════════╝"
ZSHRC

chsh -s /bin/zsh abc 2>/dev/null || true
echo "[cyber] Shell setup done."
