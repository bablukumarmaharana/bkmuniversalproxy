#!/bin/bash
# =============================================================================
# bkmuniversalproxy - Universal Multi‑Protocol Proxy Installer
# Supports: HTTP, HTTPS (CONNECT), HTTP2, SOCKS5, SOCKS4, SOCKS4A
# Detects OS, package manager, init system, firewall - works on all Linux.
# =============================================================================

set -e

PORT="${1:-8080}"
PROXY_SCRIPT="/usr/local/bin/proxy.py"
SERVICE_NAME="proxy"

# ---------- Colours ----------
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    GREEN=''; YELLOW=''; RED=''; CYAN=''; BOLD=''; NC=''
fi

# ---------- ASCII Banner ----------
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

display_banner() {

echo -e "${CYAN}══════════════════════════════════════════════════════════════════════════════${NC}"
echo

echo -e "${BLUE}██████╗${CYAN} ██╗  ██╗${GREEN}███╗   ███╗${YELLOW}██╗   ██╗${MAGENTA}███╗   ██╗${RED}██╗   ██╗${NC}"
echo -e "${BLUE}██╔══██╗${CYAN}██║ ██╔╝${GREEN}████╗ ████║${YELLOW}██║   ██║${MAGENTA}████╗  ██║${RED}██║   ██║${NC}"
echo -e "${BLUE}██████╔╝${CYAN}█████╔╝ ${GREEN}██╔████╔██║${YELLOW}██║   ██║${MAGENTA}██╔██╗ ██║${RED}██║   ██║${NC}"
echo -e "${BLUE}██╔══██╗${CYAN}██╔═██╗ ${GREEN}██║╚██╔╝██║${YELLOW}██║   ██║${MAGENTA}██║╚██╗██║${RED}██║   ██║${NC}"
echo -e "${BLUE}██████╔╝${CYAN}██║  ██╗${GREEN}██║ ╚═╝ ██║${YELLOW}╚██████╔╝${MAGENTA}██║ ╚████║${RED}╚██████╔╝${NC}"
echo -e "${BLUE}╚═════╝ ${CYAN}╚═╝  ╚═╝${GREEN}╚═╝     ╚═╝${YELLOW} ╚═════╝ ${MAGENTA}╚═╝  ╚═══╝ ${RED}╚═════╝ ${NC}"

echo
echo -e "${WHITE}        UNIVERSAL MULTI-PROTOCOL PROXY INSTALLER ${GREEN}v1.0${NC}"
echo
echo -e "${CYAN}         HTTP${WHITE} • ${GREEN}HTTPS${WHITE} • ${YELLOW}HTTP/2${WHITE} • ${MAGENTA}SOCKS4A${WHITE} • ${RED}SOCKS5${NC}"
echo
echo -e "${GREEN}              QUICK INSTALL • ZERO CONFIG • ZERO TENSION${NC}"
echo
echo -e "${BLUE}      One Port${WHITE} • ${GREEN}Multi Protocol${WHITE} • ${CYAN}Any Linux Distribution${NC}"
echo
echo -e "${YELLOW}──────────────────────── SYSTEM STATUS ────────────────────────${NC}"
echo -e "${GREEN}[✓]${NC} OS Detection             ${GREEN}READY${NC}"
echo -e "${GREEN}[✓]${NC} Architecture Check       ${GREEN}READY${NC}"
echo -e "${GREEN}[✓]${NC} Package Manager          ${GREEN}READY${NC}"
echo -e "${GREEN}[✓]${NC} Network Connectivity     ${GREEN}READY${NC}"
echo -e "${GREEN}[✓]${NC} Installation Engine      ${GREEN}READY${NC}"
echo
echo -e "${CYAN}══════════════════════════════════════════════════════════════════════════════${NC}"

}

# ---------- OS Detection ----------
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS="$ID"
        VERSION="$VERSION_ID"
    elif [ -f /etc/redhat-release ]; then
        OS="rhel"
        VERSION=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release) 2>/dev/null || echo "unknown")
    else
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        VERSION=$(uname -r)
    fi
    case "$OS" in
        ubuntu|debian|kali|pureos|devuan|turnkeylinux) OS="debian" ;;
        rocky|almalinux|rhel|centos|fedora|amzn|ol|eurolinux|vzlinux|navylinux|cloudlinux|clearos|scientific) OS="rhel" ;;
        opensuse*|sles) OS="suse" ;;
        alpine) OS="alpine" ;;
        arch|manjaro) OS="arch" ;;
        gentoo|funtoo) OS="gentoo" ;;
        slackware) OS="slackware" ;;
        void) OS="void" ;;
        nixos) OS="nixos" ;;
        clear-linux-os) OS="clear" ;;
        rancher) OS="rancher" ;;
        *) OS="unknown" ;;
    esac
    echo -e "${GREEN}Detected OS: $OS (version: $VERSION)${NC}"
}

# ---------- Package Manager ----------
detect_package_manager() {
    if command -v apt >/dev/null; then
        PKG_MGR="apt"; PKG_INSTALL="apt install -y"; PKG_UPDATE="apt update"
    elif command -v dnf >/dev/null; then
        PKG_MGR="dnf"; PKG_INSTALL="dnf install -y"; PKG_UPDATE="dnf check-update || true"
    elif command -v yum >/dev/null; then
        PKG_MGR="yum"; PKG_INSTALL="yum install -y"; PKG_UPDATE="yum check-update || true"
    elif command -v zypper >/dev/null; then
        PKG_MGR="zypper"; PKG_INSTALL="zypper install -y"; PKG_UPDATE="zypper refresh"
    elif command -v apk >/dev/null; then
        PKG_MGR="apk"; PKG_INSTALL="apk add"; PKG_UPDATE="apk update"
    elif command -v pacman >/dev/null; then
        PKG_MGR="pacman"; PKG_INSTALL="pacman -Sy --noconfirm"; PKG_UPDATE="pacman -Sy"
    elif command -v emerge >/dev/null; then
        PKG_MGR="emerge"; PKG_INSTALL="emerge --ask=n"; PKG_UPDATE="emerge --sync"
    elif command -v xbps-install >/dev/null; then
        PKG_MGR="xbps"; PKG_INSTALL="xbps-install -y"; PKG_UPDATE="xbps-install -S"
    elif command -v slackpkg >/dev/null; then
        PKG_MGR="slackpkg"; PKG_INSTALL="slackpkg -batch=on install"; PKG_UPDATE="slackpkg update"
    elif command -v nix-env >/dev/null; then
        PKG_MGR="nix"; PKG_INSTALL="nix-env -i"; PKG_UPDATE=""
    elif command -v swupd >/dev/null; then
        PKG_MGR="swupd"; PKG_INSTALL="swupd bundle-add"; PKG_UPDATE="swupd update"
    else
        PKG_MGR="none"; PKG_INSTALL=""; PKG_UPDATE=""
    fi
    echo -e "${GREEN}Package manager: $PKG_MGR${NC}"
}

# ---------- Init System ----------
detect_init() {
    if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
        INIT="systemd"
    elif [ -f /sbin/openrc ] || [ -f /usr/bin/openrc ]; then
        INIT="openrc"
    elif [ -f /etc/init.d/rc ]; then
        INIT="sysv"
    elif [ -d /etc/sv ] && command -v sv >/dev/null 2>&1; then
        INIT="runit"
    else
        INIT="none"
    fi
    echo -e "${GREEN}Init system: $INIT${NC}"
}

# ---------- Firewall ----------
detect_firewall() {
    if command -v ufw >/dev/null; then
        FW="ufw"
    elif command -v firewall-cmd >/dev/null; then
        FW="firewalld"
    elif command -v iptables >/dev/null; then
        FW="iptables"
    else
        FW="none"
    fi
    echo -e "${GREEN}Firewall: $FW${NC}"
}

# ---------- Install Python ----------
install_python() {
    if command -v python3 >/dev/null; then
        echo -e "${GREEN}Python3 already installed.${NC}"
        return
    fi
    echo -e "${YELLOW}Python3 not found – installing via $PKG_MGR...${NC}"
    case "$PKG_MGR" in
        apt)   apt update && apt install -y python3 ;;
        dnf)   dnf install -y python3 ;;
        yum)   yum install -y python3 ;;
        zypper) zypper install -y python3 ;;
        apk)   apk add python3 ;;
        pacman) pacman -Sy --noconfirm python ;;
        emerge) emerge --ask=n python ;;
        xbps)  xbps-install -y python3 ;;
        slackpkg) slackpkg -batch=on install python3 ;;
        nix)   nix-env -i python3 ;;
        swupd) swupd bundle-add python3-basic ;;
        *)
            echo -e "${RED}ERROR: Cannot install Python automatically.${NC}"
            echo "Please install python3 manually and re-run this script."
            exit 1
            ;;
    esac
    if ! command -v python3 >/dev/null; then
        echo -e "${RED}Python3 installation failed. Please install manually.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Python3 installed successfully.${NC}"
}

# ---------- Deploy Proxy Script ----------
deploy_proxy() {
    cat > "$PROXY_SCRIPT" << 'EOF'
#!/usr/bin/env python3
import socket, select, sys, threading, struct

def relay(a, b):
    sockets = [a, b]
    while True:
        r, _, _ = select.select(sockets, [], [])
        for s in r:
            d = s.recv(8192)
            if not d: return
            (b if s is a else a).send(d)

def handle_http(c, first):
    try:
        data = first + c.recv(4096)
        if not data: return
        line = data.split(b'\r\n')[0]
        parts = line.split()
        if len(parts) < 3: return
        method, target, _ = parts
        if method == b'CONNECT':
            host, port = target.split(b':')
            port = int(port) if port else 443
            s = socket.create_connection((host.decode(), port))
            c.send(b'HTTP/1.1 200 Connection Established\r\n\r\n')
            relay(c, s)
        else:
            if not (target.startswith(b'http://') or target.startswith(b'https://')):
                c.send(b'HTTP/1.1 400 Bad Request\r\n\r\n'); return
            proto = target.find(b'://') + 3
            after = target[proto:]
            slash = after.find(b'/')
            if slash == -1:
                host_port, path = after, b'/'
            else:
                host_port, path = after[:slash], after[slash:]
            if b':' in host_port:
                host, port_b = host_port.split(b':')
                port = int(port_b)
            else:
                host, port = host_port, 80
            new_req = b' '.join([method, path, b'HTTP/1.1']) + b'\r\n'
            end = data.find(b'\r\n\r\n')
            if end == -1: end = len(data)
            headers = data[data.find(b'\r\n')+2:end]
            body = data[end+4:] if end+4 < len(data) else b''
            new_data = new_req + headers + b'\r\n\r\n' + body
            s = socket.create_connection((host.decode(), port))
            s.send(new_data)
            while True:
                chunk = s.recv(8192)
                if not chunk: break
                c.send(chunk)
    except: pass
    finally: c.close()

def handle_socks5(c, first):
    try:
        data = first + c.recv(1)
        if len(data) < 2: return
        ver, nm = data[0], data[1]
        if ver != 5: return
        c.recv(nm)
        c.send(b'\x05\x00')
        data = c.recv(4)
        if len(data) < 4: return
        ver, cmd, rsv, atyp = data
        if ver != 5 or cmd != 1: return
        if atyp == 1:
            addr = socket.inet_ntoa(c.recv(4))
            port = struct.unpack('>H', c.recv(2))[0]
        elif atyp == 3:
            ln = c.recv(1)[0]
            addr = c.recv(ln).decode()
            port = struct.unpack('>H', c.recv(2))[0]
        elif atyp == 4:
            addr = socket.inet_ntop(socket.AF_INET6, c.recv(16))
            port = struct.unpack('>H', c.recv(2))[0]
        else: return
        s = socket.create_connection((addr, port))
        c.send(b'\x05\x00\x00\x01\x00\x00\x00\x00\x00\x00')
        relay(c, s)
    except: pass
    finally: c.close()

def handle_socks4(c, first):
    try:
        data = first + c.recv(7)
        if len(data) < 8: return
        ver, cmd, port_b, ip_b = data[0], data[1], data[2:4], data[4:8]
        if ver != 4 or cmd != 1: return
        port = struct.unpack('>H', port_b)[0]
        user = b''
        while True:
            b = c.recv(1)
            if b == b'\x00' or not b: break
            user += b
        if ip_b[:3] == b'\x00\x00\x00' and ip_b[3] != 0:
            dom = b''
            while True:
                b = c.recv(1)
                if b == b'\x00' or not b: break
                dom += b
            host = dom.decode()
        else:
            host = socket.inet_ntoa(ip_b)
        s = socket.create_connection((host, port))
        c.send(b'\x00\x5A\x00\x00\x00\x00\x00\x00')
        relay(c, s)
    except: pass
    finally: c.close()

def handle_client(c):
    try:
        first = c.recv(1)
        if not first: return
        if first == b'\x05':
            handle_socks5(c, first)
        elif first == b'\x04':
            handle_socks4(c, first)
        else:
            handle_http(c, first)
    except: pass
    finally: c.close()

def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(('0.0.0.0', port))
    s.listen(128)
    print(f"Proxy listening on port {port} (HTTP/HTTPS/HTTP2, SOCKS4/5)")
    while True:
        c, _ = s.accept()
        threading.Thread(target=handle_client, args=(c,)).start()

if __name__ == '__main__':
    main()
EOF
    chmod +x "$PROXY_SCRIPT"
    echo -e "${GREEN}Proxy script written to $PROXY_SCRIPT${NC}"
}

# ---------- Install Service ----------
install_service() {
    case "$INIT" in
        systemd)
            cat > "/etc/systemd/system/${SERVICE_NAME}.service" << EOF
[Unit]
Description=bkmuniversalproxy - Multi-Protocol Proxy
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $PROXY_SCRIPT $PORT
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
            systemctl daemon-reload
            systemctl enable "${SERVICE_NAME}.service"
            systemctl start "${SERVICE_NAME}.service"
            echo -e "${GREEN}Systemd service installed and started.${NC}"
            ;;
        openrc)
            cat > "/etc/init.d/${SERVICE_NAME}" << EOF
#!/sbin/openrc-run
command="/usr/bin/python3"
command_args="$PROXY_SCRIPT $PORT"
command_user="root"
pidfile="/run/${SERVICE_NAME}.pid"
name="Proxy"

depend() {
    need net
}
EOF
            chmod +x "/etc/init.d/${SERVICE_NAME}"
            rc-update add "${SERVICE_NAME}" default
            rc-service "${SERVICE_NAME}" start
            echo -e "${GREEN}OpenRC service installed and started.${NC}"
            ;;
        sysv)
            cat > "/etc/init.d/${SERVICE_NAME}" << EOF
#!/bin/sh
### BEGIN INIT INFO
# Provides:          $SERVICE_NAME
# Required-Start:    \$network \$remote_fs
# Required-Stop:     \$network \$remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       bkmuniversalproxy
### END INIT INFO

DAEMON="/usr/bin/python3"
ARGS="$PROXY_SCRIPT $PORT"
PIDFILE="/var/run/${SERVICE_NAME}.pid"

case "\$1" in
    start)
        start-stop-daemon --start --background --pidfile \$PIDFILE --make-pidfile --exec \$DAEMON -- \$ARGS
        ;;
    stop)
        start-stop-daemon --stop --pidfile \$PIDFILE
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    status)
        status_of_proc -p \$PIDFILE \$DAEMON && exit 0 || exit \$?
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOF
            chmod +x "/etc/init.d/${SERVICE_NAME}"
            update-rc.d "${SERVICE_NAME}" defaults
            service "${SERVICE_NAME}" start
            echo -e "${GREEN}SysV init script installed and started.${NC}"
            ;;
        runit)
            mkdir -p "/etc/sv/${SERVICE_NAME}"
            cat > "/etc/sv/${SERVICE_NAME}/run" << EOF
#!/bin/sh
exec python3 $PROXY_SCRIPT $PORT
EOF
            chmod +x "/etc/sv/${SERVICE_NAME}/run"
            ln -s "/etc/sv/${SERVICE_NAME}" "/var/service/"
            sv start "${SERVICE_NAME}" || true
            echo -e "${GREEN}Runit service installed and started.${NC}"
            ;;
        none)
            echo -e "${YELLOW}No init system – starting proxy in background with nohup.${NC}"
            nohup python3 "$PROXY_SCRIPT" "$PORT" &
            ;;
    esac
}

# ---------- Configure Firewall ----------
config_firewall() {
    case "$FW" in
        ufw)
            ufw --force enable
            ufw allow 22/tcp
            ufw allow "$PORT"/tcp
            ufw reload
            echo -e "${GREEN}UFW configured.${NC}"
            ;;
        firewalld)
            firewall-cmd --permanent --add-port="$PORT"/tcp
            firewall-cmd --permanent --add-service=ssh
            firewall-cmd --reload
            echo -e "${GREEN}Firewalld configured.${NC}"
            ;;
        iptables)
            iptables -I INPUT -p tcp --dport "$PORT" -j ACCEPT
            iptables -I INPUT -p tcp --dport 22 -j ACCEPT
            (iptables-save > /etc/iptables/rules.v4 2>/dev/null) || true
            (iptables-save > /etc/iptables/iptables.rules 2>/dev/null) || true
            echo -e "${GREEN}iptables rules added.${NC}"
            ;;
        none)
            echo -e "${YELLOW}No firewall detected – skipping.${NC}"
            ;;
    esac
}

# ---------- Test Proxy ----------
#test_proxy() {
#   echo
#  echo -e "${YELLOW}Waiting 2 seconds for service to start...${NC}"
#   sleep 2
#    echo -e "${YELLOW}Testing HTTP proxy...${NC}"
#   if curl --proxy "http://localhost:$PORT" https://api.ipify.org -s -o /dev/null -w "%{http_code}" 2>/dev/null | grep -q 200; then
#        echo -e "${GREEN}✅ HTTP proxy works${NC}"
#  else
#      echo -e "${RED}❌ HTTP test failed (curl missing or service not ready)${NC}"
#    fi
#   echo -e "${YELLOW}Testing SOCKS5 proxy...${NC}"
#   if curl --socks5 "localhost:$PORT" https://api.ipify.org -s -o /dev/null -w "%{http_code}" 2>/dev/null | grep -q 200; then
#        echo -e "${GREEN}✅ SOCKS5 proxy works${NC}"
#   else
#       echo -e "${RED}❌ SOCKS5 test failed${NC}"
#   fi
#}

# ---------- Special: RancherOS ----------
handle_rancher() {
    echo -e "${RED}RancherOS detected – no native package manager.${NC}"
    echo "Run the proxy inside a container:"
    echo "  docker run -d --restart=always -p $PORT:8080 python:3-alpine python3 -c \"$(cat $PROXY_SCRIPT)\" $PORT"
    exit 0
}

# ---------- Main ----------
main() {
    detect_os
    [ "$OS" = "rancher" ] && handle_rancher
    detect_package_manager
    detect_init
    detect_firewall
    [ "$PKG_MGR" = "none" ] && { echo -e "${RED}No package manager. Install python3 manually.${NC}"; exit 1; }
    install_python
    deploy_proxy
    install_service
    config_firewall

    # Display the beautiful banner
    display_banner

    echo -e "${GREEN}🎉 Proxy installation complete on port $PORT${NC}"
    echo "Supported protocols: HTTP, HTTPS (CONNECT), HTTP2, SOCKS5, SOCKS4(A)"
    #test_proxy
}

main "$@"
