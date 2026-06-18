# 🚀 BKMUniversalProxy

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.6%2B-blue.svg)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)](https://www.linux.org/)

**One script. One port. All protocols. Any Linux.**

BKMUniversalProxy is a lightweight, zero‑dependency multi‑protocol proxy server that runs on **any Linux distribution** – from Ubuntu 14.04 to RHEL 9, from Alpine to Arch, from Gentoo to Slackware. It automatically detects your OS, package manager, init system, and firewall, then sets up a fully functional proxy in seconds.

╔═══════════════════════════════════════════════════════════════════╗
║ ║
║ B K M U N I V E R S A L P R O X Y ║
║ ║
║ Universal Multi-Protocol Proxy Installer v1.0 ║
║ HTTP/HTTPS/HTTP2 | SOCKS4(A) | SOCKS5 ║
║ ║
║ 📦 One-port, multi-protocol proxy for any Linux ║
║ 🚀 Zero external dependencies – pure Python ║
║ ║
╚═══════════════════════════════════════════════════════════════════╝


---

## ✨ Features

- ✅ **HTTP forward proxy** – handles plain HTTP requests with URL rewriting.
- ✅ **HTTPS / HTTP2 CONNECT tunnel** – supports TLS tunnels for any protocol.
- ✅ **SOCKS5** – full implementation (IPv4, IPv6, domain names, no auth).
- ✅ **SOCKS4 & SOCKS4A** – includes domain name resolution (SOCKS4A).
- 🔀 **All protocols on a single port** – automatic detection by first byte.
- 🐍 **Pure Python** – uses only the standard library; no `pip` install required.
- 🖥️ **Universal OS support** – works on 20+ Linux distributions and all versions.
- 🔧 **Smart installer** – detects package manager, init system, and firewall.
- 🔄 **Persistent service** – automatically sets up systemd / OpenRC / SysV / runit.
- 🛡️ **Firewall configuration** – opens the required port (UFW, firewalld, iptables).

---

## 🚀 Quick Install

Just run this single command (as `root` or with `sudo`):

```bash
curl -sSL https://raw.githubusercontent.com/bablu-kumar/bkmuniversalproxy/main/install.sh | bash
