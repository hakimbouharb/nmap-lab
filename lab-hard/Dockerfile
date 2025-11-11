FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install all advanced services for hard lab
RUN apt-get update && \
    apt-get install -yq \
    apache2 \
    openssh-server \
    postfix \
    dovecot-pop3d \
    dovecot-imapd \
    samba \
    samba-common-bin \
    mariadb-server \
    bind9 \
    dnsutils \
    ntpsec \
    snmp \
    snmpd \
    redis-server \
    avahi-daemon \
    cups \
    vsftpd \
    telnetd \
    iptables \
    netcat-openbsd \
    net-tools \
    procps \
    ssl-cert \
    socat \
    && apt-get autoclean \
    && apt-get autoremove -yq \
    && rm -rf /var/lib/apt/lists/*

# Create flag file (deeply hidden)
RUN mkdir -p /var/www/html/.hidden/deep/path && \
    echo '<html><body><h1>Hard Lab Target</h1><p>Advanced enumeration required...</p></body></html>' > /var/www/html/index.html && \
    echo 'HTB{h4rd_st34lthy_sc4n}' > /root/.flag.txt && \
    echo 'HTB{h4rd_st34lthy_sc4n}' > /var/www/html/.hidden/deep/path/flag.txt && \
    chown -R www-data:www-data /var/www/html

# Configure Apache with SSL
RUN a2enmod ssl && \
    a2enmod headers && \
    a2ensite default-ssl && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "ServerTokens Full" >> /etc/apache2/apache2.conf && \
    echo "ServerSignature On" >> /etc/apache2/apache2.conf

# Configure SSH (hardened)
RUN mkdir -p /var/run/sshd && \
    echo 'root:C0mpl3xP@ssw0rd!' | chpasswd && \
    useradd -m -s /bin/bash sysadmin && \
    echo 'sysadmin:Syst3mAdm1n!' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configure Postfix
RUN postconf -e 'inet_interfaces = all' && \
    postconf -e 'inet_protocols = ipv4' && \
    postconf -e 'smtpd_banner = $myhostname ESMTP'

# Configure Dovecot
RUN sed -i 's/#disable_plaintext_auth = yes/disable_plaintext_auth = no/' /etc/dovecot/conf.d/10-auth.conf

# Configure Samba
RUN echo '[global]' > /etc/samba/smb.conf && \
    echo '   workgroup = WORKGROUP' >> /etc/samba/smb.conf && \
    echo '   server string = Hard Lab Samba' >> /etc/samba/smb.conf && \
    echo '   security = user' >> /etc/samba/smb.conf && \
    echo '   map to guest = Bad User' >> /etc/samba/smb.conf && \
    echo '   smb ports = 445 139' >> /etc/samba/smb.conf

# Configure SNMP
RUN echo "rocommunity public 0.0.0.0/0" > /etc/snmp/snmpd.conf && \
    echo "sysLocation Hard Lab" >> /etc/snmp/snmpd.conf && \
    echo "sysContact admin@hardlab.local" >> /etc/snmp/snmpd.conf && \
    echo "agentaddress udp:161" >> /etc/snmp/snmpd.conf

# Configure Redis
RUN sed -i 's/bind 127.0.0.1 -::1/bind 0.0.0.0/' /etc/redis/redis.conf || \
    sed -i 's/bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf

# Configure BIND9 DNS
RUN echo 'options {' > /etc/bind/named.conf.options && \
    echo '    directory "/var/cache/bind";' >> /etc/bind/named.conf.options && \
    echo '    listen-on { any; };' >> /etc/bind/named.conf.options && \
    echo '    allow-query { any; };' >> /etc/bind/named.conf.options && \
    echo '    recursion yes;' >> /etc/bind/named.conf.options && \
    echo '    dnssec-validation no;' >> /etc/bind/named.conf.options && \
    echo '};' >> /etc/bind/named.conf.options

# Configure NTP
RUN mkdir -p /var/lib/ntpsec && \
    echo "server 0.pool.ntp.org iburst" > /etc/ntpsec/ntp.conf && \
    echo "driftfile /var/lib/ntpsec/ntp.drift" >> /etc/ntpsec/ntp.conf

# Configure MySQL
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld

# Create custom vulnerable service on port 9999
RUN echo '#!/bin/bash' > /usr/local/bin/banner-service.sh && \
    echo 'while true; do' >> /usr/local/bin/banner-service.sh && \
    echo '  echo -e "HTTP/1.1 200 OK\r\nServer: HardLabCustom/1.0\r\n\r\nFlag hint: Check unusual ports" | nc -l -p 9999 -q 1' >> /usr/local/bin/banner-service.sh && \
    echo 'done' >> /usr/local/bin/banner-service.sh && \
    chmod +x /usr/local/bin/banner-service.sh

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "=== Starting Hard Lab Container ==="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start MySQL' >> /start.sh && \
    echo 'echo "[+] Starting MySQL on port 3306..."' >> /start.sh && \
    echo 'service mariadb start' >> /start.sh && \
    echo 'sleep 3' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start all services' >> /start.sh && \
    echo 'echo "[+] Starting SSH on port 22..."' >> /start.sh && \
    echo 'service ssh start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Apache on ports 80/443..."' >> /start.sh && \
    echo 'service apache2 start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Postfix (SMTP) on port 25..."' >> /start.sh && \
    echo 'service postfix start 2>/dev/null || true' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Dovecot (POP3/IMAP)..."' >> /start.sh && \
    echo 'service dovecot start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Samba (SMB)..."' >> /start.sh && \
    echo 'service smbd start' >> /start.sh && \
    echo 'service nmbd start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting DNS (BIND9) on port 53..."' >> /start.sh && \
    echo 'service named start 2>/dev/null || service bind9 start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting NTP on port 123..."' >> /start.sh && \
    echo 'service ntpsec start 2>/dev/null || true' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting SNMP on port 161..."' >> /start.sh && \
    echo 'service snmpd start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Redis on port 6379..."' >> /start.sh && \
    echo 'service redis-server start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Avahi (mDNS) on port 5353..."' >> /start.sh && \
    echo 'service avahi-daemon start 2>/dev/null || true' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting CUPS on port 631..."' >> /start.sh && \
    echo 'service cups start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting custom service on port 9999..."' >> /start.sh && \
    echo '/usr/local/bin/banner-service.sh &' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Simulate DHCP client on port 68' >> /start.sh && \
    echo 'socat UDP-LISTEN:68,fork EXEC:"/bin/cat" &' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Configure ADVANCED iptables rules' >> /start.sh && \
    echo 'echo "[+] Configuring advanced firewall rules..."' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Rate limiting on SSH (makes timing attacks necessary)' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 10 -j DROP' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Multiple filtered ports (DROP - stealth required)' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 139 -j DROP' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 138 -j DROP' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 68 -j DROP' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 631 -j DROP' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Rejected ports' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 21 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 3389 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Random port filtering (students must discover)' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 8080 -j DROP' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 8443 -j DROP' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Hard Lab Ready ==="' >> /start.sh && \
    echo 'echo "Target IP: 172.25.0.13"' >> /start.sh && \
    echo 'echo "Difficulty: HARD"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "⚠️  WARNING: This lab has advanced security measures!"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Open Ports (if you can find them):"' >> /start.sh && \
    echo 'echo "  - 22/tcp   (SSH - rate limited!)"' >> /start.sh && \
    echo 'echo "  - 25/tcp   (SMTP)"' >> /start.sh && \
    echo 'echo "  - 53/tcp   (DNS)"' >> /start.sh && \
    echo 'echo "  - 53/udp   (DNS)"' >> /start.sh && \
    echo 'echo "  - 80/tcp   (HTTP)"' >> /start.sh && \
    echo 'echo "  - 110/tcp  (POP3)"' >> /start.sh && \
    echo 'echo "  - 123/udp  (NTP)"' >> /start.sh && \
    echo 'echo "  - 143/tcp  (IMAP)"' >> /start.sh && \
    echo 'echo "  - 161/udp  (SNMP)"' >> /start.sh && \
    echo 'echo "  - 443/tcp  (HTTPS)"' >> /start.sh && \
    echo 'echo "  - 445/tcp  (SMB)"' >> /start.sh && \
    echo 'echo "  - 3306/tcp (MySQL)"' >> /start.sh && \
    echo 'echo "  - 5353/udp (mDNS)"' >> /start.sh && \
    echo 'echo "  - 6379/tcp (Redis)"' >> /start.sh && \
    echo 'echo "  - 9999/tcp (Custom)"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Heavily Filtered (stealth scan required):"' >> /start.sh && \
    echo 'echo "  - Multiple ports with DROP rules"' >> /start.sh && \
    echo 'echo "  - Rate limiting on critical services"' >> /start.sh && \
    echo 'echo "  - Random port blocking"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Hints:"' >> /start.sh && \
    echo 'echo "  - Use timing templates wisely"' >> /start.sh && \
    echo 'echo "  - Fragment your packets"' >> /start.sh && \
    echo 'echo "  - Try decoy scanning"' >> /start.sh && \
    echo 'echo "  - NSE scripts are your friend"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Keep container running' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh && \
    chmod +x /start.sh

# Expose all ports
EXPOSE 22 25 53 80 110 123 143 443 445 3306 5353 6379 9999
EXPOSE 21 23 139 3389 8080 8443
EXPOSE 53/udp 68/udp 123/udp 137/udp 138/udp 161/udp 631/udp 5353/udp

CMD ["/start.sh"]