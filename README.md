# Cyber Offensive Desktop

Cloud pentesting workstation in GitHub Codespaces. XFCE desktop via browser.

## Launch Speed

| Mode | First Launch | Subsequent |
|------|-------------|------------|
| Without GHCR | ~8-12 min | ~2-3 min (cached) |
| **With GHCR (recommended)** | **~30-45s** | **~15-30s** |

## Setup (5 minutes, once)

```bash
# 1. Push to GitHub
git init && git add -A && git commit -m "init"
gh repo create cyber-desktop --private --push --source .

# 2. Build the image via GitHub Actions
#    Go to repo → Actions → "Build Cyber Desktop Image" → Run workflow
#    Wait ~10 min for it to finish

# 3. Enable fast mode (optional)
# If you want to hardcode the prebuilt image path, use:
#    bash enable-fast-mode.sh <your-username> <repo-name>
# Otherwise the bootstrap script now auto-detects the repo and pulls the correct GHCR image.
#
# 4. Launch Codespace — done in 30s
```

## Without GHCR (still works)

Just open the repo in Codespaces. First build takes ~10min (Docker builds
locally), rebuilds are faster if cache is preserved.

## Config

Edit the top of `.devcontainer/start-webtop.sh`:
```bash
TIMEZONE="Europe/Paris"
KEYBOARD="fr"
```

## Tools

**Recon:** nmap, masscan, subfinder, httpx, nuclei, gau, waybackurls, hakrawler, dnsrecon
**Web:** sqlmap, nikto, ffuf, wfuzz, gobuster, dirb
**AD/Windows:** impacket, crackmapexec, certipy-ad, bloodhound
**Cracking:** john, hashcat, hydra
**Binary:** gdb, radare2, pwntools, binwalk, ltrace, strace
**Network:** netcat, tcpdump, wireshark, socat, proxychains4
**VPN:** openvpn, wireguard
**Forensics:** volatility3, binwalk

## Directories

```
/opt/wordlists/SecLists/   SecLists
/opt/privesc/              linpeas, winpeas, pspy
/opt/tools/                Your custom tools
/opt/venv/                 Python pentest venv
/opt/go/bin/               Go tools
```

## Shell

ZSH with oh-my-zsh. Key aliases:

```bash
htb-init <name>      # Create HTB workspace
ctf-init <name>      # Create CTF workspace
bb-init <name>       # Create bug bounty workspace

nmapq <ip>           # Quick scan (-sC -sV)
nmapf <ip>           # Full scan (-p-)
ffuf-dir <url>/FUZZ  # Dir fuzzing
ffuf-files <url>/FUZZ
lnc <port>           # Netcat listener
serve                # HTTP server :8888
myip                 # External IP
```

## Tmux

Prefix: `Ctrl+A`

| Key | Action |
|-----|--------|
| `Ctrl+A \|` | Split horizontal |
| `Ctrl+A -` | Split vertical |
| `Alt+Arrow` | Move between panes |
| `Ctrl+A P` | Pentest layout (3 panes) |

## Adding Tools

- **apt packages** → add to Dockerfile Layer 1
- **Go tools** → add `go install` in Layer 2
- **Python** → add to `pip install` in Layer 3
- **Custom** → drop in `/opt/tools/`

After changes: push → Actions rebuilds image → next launch is fast.
