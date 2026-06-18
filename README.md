```markdown
# 🚀 BKMUniversalProxy

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.6%2B-blue.svg)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)](https://www.linux.org/)

**One script. One port. All protocols. Any Linux.**

BKMUniversalProxy is a lightweight, zero‑dependency multi‑protocol proxy server that runs on **any Linux distribution** – from Ubuntu 14.04 to RHEL 9, from Alpine to Arch, from Gentoo to Slackware. It automatically detects your OS, package manager, init system, and firewall, then sets up a fully functional proxy in seconds.

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║           B K M U N I V E R S A L P R O X Y                      ║
║                                                                   ║
║   Universal Multi-Protocol Proxy Installer v1.0                  ║
║   HTTP/HTTPS/HTTP2 | SOCKS4(A) | SOCKS5                         ║
║                                                                   ║
║   📦 One-port, multi-protocol proxy for any Linux               ║
║   🚀 Zero external dependencies – pure Python                   ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

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
curl -sSL https://raw.githubusercontent.com/bablukumarmaharana/bkmuniversalproxy/main/install.sh | bash
```

Or, if you have the script locally:

```bash
chmod +x install.sh
./install.sh          # uses port 8080
./install.sh 9090     # uses custom port
```

The installer will:

1. Detect your Linux distribution, version, package manager, init system, and firewall.
2. Install Python 3 if missing.
3. Deploy the proxy script to `/usr/local/bin/proxy.py` (embedded within `install.sh`).
4. Create and start a persistent system service.
5. Open the firewall for your chosen port.
6. Test the proxy with `curl` and show a beautiful ASCII banner.

---

## 📦 Supported Protocols

| Protocol | Support | Details |
|----------|---------|---------|
| **HTTP** (forward proxy) | ✅ Full | Rewrites request URLs and forwards to destination. |
| **HTTPS** (CONNECT) | ✅ Full | Creates a TCP tunnel; works for any TLS traffic (including HTTP/2). |
| **HTTP/2** (via CONNECT) | ✅ Full | Since it's just a TLS tunnel, HTTP/2 works seamlessly. |
| **SOCKS5** | ✅ Full | Supports IPv4, IPv6, domain names; no authentication. |
| **SOCKS4** | ✅ Full | Basic SOCKS4 with IPv4 addresses. |
| **SOCKS4A** | ✅ Full | Domain name resolution via the proxy (0.0.0.x pattern). |

All protocols listen on the **same TCP port** – the proxy distinguishes them by the first byte of the connection.

---

## 🖥️ Supported Operating Systems & Versions

BKMUniversalProxy works on **any Linux distribution** released after ~2014, and many older ones. The installer detects your environment and adapts automatically.

| Distribution | Versions Tested | Package Manager | Init System |
|--------------|----------------|-----------------|-------------|
| **Ubuntu** | 14.04, 16.04, 18.04, 20.04, 22.04, 24.04 | `apt` | systemd / upstart |
| **Debian** | 8, 9, 10, 11, 12 | `apt` | systemd / sysv |
| **Kali Linux** | Rolling | `apt` | systemd |
| **PureOS** | 10+ | `apt` | systemd |
| **Devuan** | 3, 4, 5 | `apt` | sysv / openrc |
| **TurnKey Linux** | All | `apt` | systemd |
| **Rocky Linux** | 8, 9 | `dnf` / `yum` | systemd |
| **AlmaLinux** | 8, 9 | `dnf` / `yum` | systemd |
| **RHEL** | 6, 7, 8, 9 | `yum` / `dnf` | sysv / systemd |
| **CentOS** | 6, 7, 8, Stream 8/9 | `yum` / `dnf` | sysv / systemd |
| **Fedora** | 30–40 | `dnf` | systemd |
| **Amazon Linux** | 2, 2023 | `yum` / `dnf` | systemd |
| **Oracle Linux** | 7, 8, 9 | `yum` / `dnf` | systemd |
| **EuroLinux / VzLinux / Navy / CloudLinux / ClearOS / Scientific** | All | `yum` / `dnf` | systemd |
| **openSUSE Leap** | 15.x | `zypper` | systemd |
| **SLES** | 12, 15 | `zypper` | systemd |
| **Alpine Linux** | 3.12–3.20 | `apk` | openrc |
| **Arch Linux** | Rolling | `pacman` | systemd |
| **Manjaro** | Rolling | `pacman` | systemd |
| **Gentoo** | Current | `emerge` | openrc / systemd |
| **Slackware** | 14.2, 15.0 | `slackpkg` | sysv |
| **Void Linux** | Current | `xbps` | runit |
| **NixOS** | 23.11+ | `nix-env` | systemd |
| **Clear Linux** | Latest | `swupd` | systemd |
| **RancherOS** | All | – (no pkg mgr) | systemd (container instructions) |

If your distribution is not listed, the installer will likely still work – it falls back to generic detection and manual prompts if needed.

---

## 🔧 Manual Installation (without the installer)

If you prefer to install manually, you can extract the proxy code from `install.sh` and run it directly.

```bash
# Extract the embedded proxy script
sed -n '/^cat > "\$PROXY_SCRIPT" << .*EOF/,/^EOF/p' install.sh | head -n -1 | tail -n +2 > proxy.py
python3 proxy.py 8080
```

Or simply run the installer with the `--manual` flag (not implemented – but you can run the script directly as above).

---

## 🧪 Testing Your Proxy

After installation, test the proxy using `curl`:

### HTTP Proxy
```bash
curl --proxy http://localhost:8080 https://api.ipify.org
```

### SOCKS5 Proxy
```bash
curl --socks5 localhost:8080 https://api.ipify.org
```

### SOCKS4 Proxy
```bash
curl --socks4 localhost:8080 https://api.ipify.org
```

### HTTPS CONNECT (using a web browser or any HTTPS client)
Set your browser's proxy to `localhost:8080` and visit any HTTPS site.

---

## 📂 Repository Structure

```
.
├── install.sh          # The universal installer (embeds the proxy script)
├── README.md           # This file
└── LICENSE             # MIT License
```

> **Note:** The actual proxy code is embedded inside `install.sh` – no separate `proxy.py` file is needed.

---

## 🤝 Contributing

Contributions are welcome! If you find a bug, have a feature request, or want to add support for a new distribution, please open an issue or submit a pull request.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test on at least two different distributions.
5. Submit a PR with a clear description.

---

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 Bablu Kumar Maharana

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
...
```

---

## 🙏 Acknowledgements

- Inspired by [gost](https://github.com/ginuerzh/gost) – but designed to be lighter, more portable, and with a smarter installer.
- Built with pure Python and a lot of `select()`.

---

## 📬 Contact

**Bablu Kumar Maharana**  
GitHub: [@bablukumarmaharana](https://github.com/bablukumarmaharana)  
Project: [bkmuniversalproxy](https://github.com/bablukumarmaharana/bkmuniversalproxy)

---

**Star ⭐ this repository if you find it useful!**
```
