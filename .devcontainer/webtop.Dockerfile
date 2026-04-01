FROM linuxserver/webtop:ubuntu-xfce

RUN apt-get update && apt-get install -y \
    firefox \
    nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common dirb dnsutils whois \
    openvpn curl wget git python3 python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
