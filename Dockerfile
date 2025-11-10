FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Apache + PHP + additional services for nmap practice
RUN apt-get update && \
    apt-get install -yq \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    php-json \
    openssh-server \
    postfix \
    dovecot-pop3d \
    dovecot-imapd \
    samba \
    samba-common-bin \
    iptables \
    procps \
    ssl-cert \
    iproute2 \
    avahi-daemon \
    cups \
    isc-dhcp-client \
    socat \
    vsftpd \
    telnetd \
    mariadb-server \
    netcat-openbsd \
    net-tools \
    bind9 \
    dnsutils \
    ntpsec \
    ntpsec-ntpdate \
    snmp \
    snmpd \
    redis-server \
    && apt-get autoclean \
    && apt-get autoremove -yq \
    && rm -rf /var/lib/apt/lists/*

# Create web application directory structure
RUN mkdir -p /var/www/html/api && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Configure NTP (using ntpsec)
RUN mkdir -p /var/lib/ntpsec && \
    echo "server 0.debian.pool.ntp.org iburst" > /etc/ntpsec/ntp.conf && \
    echo "server 1.debian.pool.ntp.org iburst" >> /etc/ntpsec/ntp.conf && \
    echo "server 2.debian.pool.ntp.org iburst" >> /etc/ntpsec/ntp.conf && \
    echo "server 3.debian.pool.ntp.org iburst" >> /etc/ntpsec/ntp.conf && \
    echo "driftfile /var/lib/ntpsec/ntp.drift" >> /etc/ntpsec/ntp.conf && \
    echo "restrict default kod nomodify notrap nopeer noquery" >> /etc/ntpsec/ntp.conf && \
    echo "restrict 127.0.0.1" >> /etc/ntpsec/ntp.conf

# Configure SNMP
RUN echo "rocommunity public 0.0.0.0/0" > /etc/snmp/snmpd.conf && \
    echo "sysLocation Nmap Training Lab" >> /etc/snmp/snmpd.conf && \
    echo "sysContact Admin <admin@nmaptraining.local>" >> /etc/snmp/snmpd.conf && \
    echo "agentaddress udp:161" >> /etc/snmp/snmpd.conf

# Configure Redis to listen on all interfaces
RUN sed -i 's/bind 127.0.0.1 -::1/bind 0.0.0.0/' /etc/redis/redis.conf || \
    sed -i 's/bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf

# Configure BIND9 DNS server
RUN echo 'options {' > /etc/bind/named.conf.options && \
    echo '    directory "/var/cache/bind";' >> /etc/bind/named.conf.options && \
    echo '    listen-on { any; };' >> /etc/bind/named.conf.options && \
    echo '    listen-on-v6 { any; };' >> /etc/bind/named.conf.options && \
    echo '    allow-query { any; };' >> /etc/bind/named.conf.options && \
    echo '    recursion yes;' >> /etc/bind/named.conf.options && \
    echo '    allow-recursion { any; };' >> /etc/bind/named.conf.options && \
    echo '    dnssec-validation no;' >> /etc/bind/named.conf.options && \
    echo '};' >> /etc/bind/named.conf.options

RUN echo 'zone "nmaptraining.local" {' >> /etc/bind/named.conf.local && \
    echo '    type master;' >> /etc/bind/named.conf.local && \
    echo '    file "/etc/bind/db.nmaptraining.local";' >> /etc/bind/named.conf.local && \
    echo '};' >> /etc/bind/named.conf.local

RUN echo '$TTL 604800' > /etc/bind/db.nmaptraining.local && \
    echo '@ IN SOA nmaptraining.local. admin.nmaptraining.local. (' >> /etc/bind/db.nmaptraining.local && \
    echo '    1         ; Serial' >> /etc/bind/db.nmaptraining.local && \
    echo '    604800    ; Refresh' >> /etc/bind/db.nmaptraining.local && \
    echo '    86400     ; Retry' >> /etc/bind/db.nmaptraining.local && \
    echo '    2419200   ; Expire' >> /etc/bind/db.nmaptraining.local && \
    echo '    604800 )  ; Negative Cache TTL' >> /etc/bind/db.nmaptraining.local && \
    echo ';' >> /etc/bind/db.nmaptraining.local && \
    echo '@ IN NS ns.nmaptraining.local.' >> /etc/bind/db.nmaptraining.local && \
    echo '@ IN A 127.0.0.1' >> /etc/bind/db.nmaptraining.local && \
    echo 'ns IN A 127.0.0.1' >> /etc/bind/db.nmaptraining.local && \
    echo 'www IN A 127.0.0.1' >> /etc/bind/db.nmaptraining.local

# Remove default Apache index file
RUN rm -f /var/www/html/index.html

# Configure Apache first (before copying files)
RUN a2enmod rewrite && \
    a2enmod ssl && \
    a2ensite default-ssl && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "ServerTokens Full" >> /etc/apache2/apache2.conf && \
    echo "ServerSignature On" >> /etc/apache2/apache2.conf

# Configure PHP session settings
RUN mkdir -p /var/lib/php/sessions && \
    chown -R www-data:www-data /var/lib/php/sessions && \
    chmod -R 700 /var/lib/php/sessions

# Copy database initialization script
COPY init-database.sql /tmp/init-database.sql

# Copy web application files
COPY *.php *.html /var/www/html/
COPY api/ /var/www/html/api/

# Create vulnerable PHP pages for nmap practice
RUN echo '<?php phpinfo(); ?>' > /var/www/html/info.php && \
    echo '<?php if (isset($_GET["id"])) { echo "SQLi vuln: " . $_GET["id"]; } ?>' > /var/www/html/vuln.php && \
    echo '<?php if (isset($_GET["os"])) { echo php_uname("a"); } else { echo "Status: OK. Add ?os=1 to query OS."; } ?>' > /var/www/html/status.php

# Set proper permissions after copying all files
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/ && \
    find /var/www/html -type f -name "*.html" -exec chmod 644 {} \; && \
    find /var/www/html -type f -name "*.php" -exec chmod 644 {} \;

# Configure SSH with weak settings
RUN mkdir -p /var/run/sshd && \
    echo 'root:password123' | chpasswd && \
    useradd -m -s /bin/bash admin && \
    echo 'admin:admin' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configure Postfix (minimal setup for SMTP)
RUN postconf -e 'inet_interfaces = all' && \
    postconf -e 'inet_protocols = ipv4' && \
    postconf -e 'smtpd_banner = $myhostname ESMTP Postfix (Vulnerable Test Server)' && \
    postconf -e 'mynetworks = 0.0.0.0/0'

# Configure Dovecot for POP3 and IMAP
RUN sed -i 's/#disable_plaintext_auth = yes/disable_plaintext_auth = no/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/#listen = \*, ::/listen = \*/' /etc/dovecot/dovecot.conf

# Configure Samba with open share
RUN echo '[global]' > /etc/samba/smb.conf && \
    echo '   workgroup = WORKGROUP' >> /etc/samba/smb.conf && \
    echo '   server string = Samba Server %v' >> /etc/samba/smb.conf && \
    echo '   security = user' >> /etc/samba/smb.conf && \
    echo '   map to guest = Bad User' >> /etc/samba/smb.conf && \
    echo '   dns proxy = no' >> /etc/samba/smb.conf && \
    echo '   smb ports = 445 139' >> /etc/samba/smb.conf && \
    echo '   bind interfaces only = no' >> /etc/samba/smb.conf && \
    echo '   interfaces = 0.0.0.0/0' >> /etc/samba/smb.conf && \
    echo '' >> /etc/samba/smb.conf && \
    echo '[share]' >> /etc/samba/smb.conf && \
    echo '   path = /tmp' >> /etc/samba/smb.conf && \
    echo '   browsable = yes' >> /etc/samba/smb.conf && \
    echo '   read only = no' >> /etc/samba/smb.conf && \
    echo '   guest ok = yes' >> /etc/samba/smb.conf && \
    echo '   create mask = 0777' >> /etc/samba/smb.conf

# Configure FTP (will be stopped for REJECTED port testing)
RUN echo 'listen=YES' > /etc/vsftpd.conf && \
    echo 'anonymous_enable=YES' >> /etc/vsftpd.conf && \
    echo 'local_enable=YES' >> /etc/vsftpd.conf && \
    echo 'write_enable=YES' >> /etc/vsftpd.conf && \
    echo 'anon_upload_enable=YES' >> /etc/vsftpd.conf && \
    echo 'anon_mkdir_write_enable=YES' >> /etc/vsftpd.conf && \
    echo 'dirmessage_enable=YES' >> /etc/vsftpd.conf && \
    echo 'xferlog_enable=YES' >> /etc/vsftpd.conf && \
    echo 'connect_from_port_20=YES' >> /etc/vsftpd.conf && \
    echo 'ftpd_banner=Welcome to vulnerable FTP service.' >> /etc/vsftpd.conf

# Configure MySQL
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld

# Create startup script with FIXED database initialization
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "=== Starting Nmap Training Platform ==="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start MySQL first' >> /start.sh && \
    echo 'echo "[+] Starting MySQL on port 3306..."' >> /start.sh && \
    echo 'service mariadb start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Wait for MySQL to be ready' >> /start.sh && \
    echo 'echo "[+] Waiting for MySQL to initialize..."' >> /start.sh && \
    echo 'for i in {1..30}; do' >> /start.sh && \
    echo '    if mysqladmin ping --silent 2>/dev/null; then' >> /start.sh && \
    echo '        echo "[+] MySQL is ready!"' >> /start.sh && \
    echo '        break' >> /start.sh && \
    echo '    fi' >> /start.sh && \
    echo '    echo "    Waiting for MySQL... (attempt $i/30)"' >> /start.sh && \
    echo '    sleep 2' >> /start.sh && \
    echo 'done' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Initialize database' >> /start.sh && \
    echo 'if [ -f /tmp/init-database.sql ]; then' >> /start.sh && \
    echo '    echo "[+] Initializing database from init-database.sql..."' >> /start.sh && \
    echo '    mysql -u root < /tmp/init-database.sql 2>/dev/null || echo "[!] Database may already exist"' >> /start.sh && \
    echo '    echo "[+] Database initialization complete!"' >> /start.sh && \
    echo 'else' >> /start.sh && \
    echo '    echo "[!] init-database.sql not found, skipping database initialization"' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start other services' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "[+] Starting SSH on port 22..."' >> /start.sh && \
    echo 'service ssh start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Postfix (SMTP) on port 25..."' >> /start.sh && \
    echo 'service postfix start 2>/dev/null || echo "Postfix already running"' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Dovecot (POP3: 110, IMAP: 143)..."' >> /start.sh && \
    echo 'service dovecot start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Samba (SMB on 445, NetBIOS on 139)..."' >> /start.sh && \
    echo 'service smbd start' >> /start.sh && \
    echo 'service nmbd start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting CUPS (IPP on port 631)..."' >> /start.sh && \
    echo 'service cups start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting DNS server (BIND9) on port 53..."' >> /start.sh && \
    echo 'service named start 2>/dev/null || service bind9 start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting NTP server (ntpsec) on port 123..."' >> /start.sh && \
    echo 'service ntpsec start 2>/dev/null || service ntpd start 2>/dev/null || echo "NTP service name may vary"' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting SNMP server on port 161..."' >> /start.sh && \
    echo 'service snmpd start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Redis on port 6379..."' >> /start.sh && \
    echo 'service redis-server start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Avahi (mDNS) on port 5353..."' >> /start.sh && \
    echo 'service avahi-daemon start 2>/dev/null || echo "Avahi may not be available"' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Setup iptables rules for specific port states' >> /start.sh && \
    echo 'echo "[+] Configuring iptables for filtered ports..."' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# FILTERED (DROP - no response)' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 139 -j DROP    # NetBIOS Session' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 138 -j DROP    # NetBIOS Datagram' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 68 -j DROP     # DHCP Client' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 631 -j DROP    # IPP' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# CLOSED/REJECTED (REJECT - sends RST/ICMP unreachable)' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 21 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 3389 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Service Status ==="' >> /start.sh && \
    echo 'netstat -tuln 2>/dev/null | grep LISTEN | sort -n -k4 || ss -tuln | grep LISTEN | sort' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Port State Summary ==="' >> /start.sh && \
    echo 'echo "OPEN TCP: 22(SSH), 25(SMTP), 53(DNS), 80(HTTP), 110(POP3), 143(IMAP), 443(HTTPS), 445(SMB), 3306(MySQL), 6379(Redis)"' >> /start.sh && \
    echo 'echo "OPEN UDP: 53(DNS), 123(NTP), 137(NetBIOS-NS), 161(SNMP), 5353(mDNS)"' >> /start.sh && \
    echo 'echo "FILTERED TCP: 139(NetBIOS-SSN)"' >> /start.sh && \
    echo 'echo "FILTERED UDP: 68(DHCP), 138(NetBIOS-DGM), 631(IPP)"' >> /start.sh && \
    echo 'echo "CLOSED/REJECTED TCP: 21(FTP), 23(Telnet), 3389(RDP)"' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Web Application ==="' >> /start.sh && \
    echo 'echo "✓ Access the training platform at: http://YOUR_SERVER_IP:8080/"' >> /start.sh && \
    echo 'echo "✓ Admin credentials: admin@nmaptraining.local / admin123"' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "[+] Container ready for nmap scanning!"' >> /start.sh && \
    echo 'echo "[+] Test with: nmap -sS -sU -sV -O <container_ip>"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Apache runs in foreground to keep container alive' >> /start.sh && \
    echo 'echo "[+] Starting Apache web server..."' >> /start.sh && \
    echo 'exec apache2ctl -D FOREGROUND' >> /start.sh && \
    chmod +x /start.sh

# Expose TCP ports
EXPOSE 22 25 53 80 110 143 443 445 3306 6379
EXPOSE 21 23 139 3389

# Expose UDP ports
EXPOSE 53/udp 123/udp 137/udp 161/udp 5353/udp
EXPOSE 68/udp 138/udp 631/udp

CMD ["/start.sh"]