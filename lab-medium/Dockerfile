FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install medium complexity services
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
    vsftpd \
    telnetd \
    iptables \
    netcat-openbsd \
    net-tools \
    procps \
    ssl-cert \
    && apt-get autoclean \
    && apt-get autoremove -yq \
    && rm -rf /var/lib/apt/lists/*

# Create flag file
RUN mkdir -p /var/www/html && \
    echo '<html><body><h1>Medium Lab Target</h1><p>More services to enumerate...</p></body></html>' > /var/www/html/index.html && \
    echo 'HTB{m3d1um_1ds_3vas10n}' > /root/flag.txt && \
    echo 'HTB{m3d1um_1ds_3vas10n}' > /var/www/html/secret_flag.txt && \
    chown -R www-data:www-data /var/www/html

# Configure Apache with SSL
RUN a2enmod ssl && \
    a2ensite default-ssl && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "ServerTokens Full" >> /etc/apache2/apache2.conf && \
    echo "ServerSignature On" >> /etc/apache2/apache2.conf

# Configure SSH
RUN mkdir -p /var/run/sshd && \
    echo 'root:r00tpass' | chpasswd && \
    useradd -m -s /bin/bash admin && \
    echo 'admin:admin123' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configure Postfix
RUN postconf -e 'inet_interfaces = all' && \
    postconf -e 'inet_protocols = ipv4' && \
    postconf -e 'smtpd_banner = $myhostname ESMTP Postfix'

# Configure Dovecot
RUN sed -i 's/#disable_plaintext_auth = yes/disable_plaintext_auth = no/' /etc/dovecot/conf.d/10-auth.conf

# Configure Samba
RUN echo '[global]' > /etc/samba/smb.conf && \
    echo '   workgroup = WORKGROUP' >> /etc/samba/smb.conf && \
    echo '   server string = Medium Lab Samba' >> /etc/samba/smb.conf && \
    echo '   security = user' >> /etc/samba/smb.conf && \
    echo '   map to guest = Bad User' >> /etc/samba/smb.conf && \
    echo '   smb ports = 445 139' >> /etc/samba/smb.conf && \
    echo '' >> /etc/samba/smb.conf && \
    echo '[flags]' >> /etc/samba/smb.conf && \
    echo '   path = /root' >> /etc/samba/smb.conf && \
    echo '   browsable = yes' >> /etc/samba/smb.conf && \
    echo '   read only = yes' >> /etc/samba/smb.conf && \
    echo '   guest ok = yes' >> /etc/samba/smb.conf

# Configure MySQL
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "=== Starting Medium Lab Container ==="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start MySQL' >> /start.sh && \
    echo 'echo "[+] Starting MySQL on port 3306..."' >> /start.sh && \
    echo 'service mariadb start' >> /start.sh && \
    echo 'sleep 3' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start services' >> /start.sh && \
    echo 'echo "[+] Starting SSH on port 22..."' >> /start.sh && \
    echo 'service ssh start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Apache on ports 80/443..."' >> /start.sh && \
    echo 'service apache2 start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Postfix (SMTP) on port 25..."' >> /start.sh && \
    echo 'service postfix start 2>/dev/null || true' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Dovecot (POP3/IMAP) on ports 110/143..."' >> /start.sh && \
    echo 'service dovecot start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Samba (SMB) on port 445..."' >> /start.sh && \
    echo 'service smbd start' >> /start.sh && \
    echo 'service nmbd start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Configure iptables - Medium complexity' >> /start.sh && \
    echo 'echo "[+] Configuring firewall rules..."' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# NetBIOS Session port filtered (DROP)' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 139 -j DROP' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# NetBIOS Datagram filtered (DROP)' >> /start.sh && \
    echo 'iptables -A INPUT -p udp --dport 138 -j DROP' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# FTP rejected' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 21 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Telnet rejected' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Medium Lab Ready ==="' >> /start.sh && \
    echo 'echo "Target IP: 172.25.0.12"' >> /start.sh && \
    echo 'echo "Difficulty: Medium"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Open Ports:"' >> /start.sh && \
    echo 'echo "  - 22/tcp   (SSH)"' >> /start.sh && \
    echo 'echo "  - 25/tcp   (SMTP)"' >> /start.sh && \
    echo 'echo "  - 80/tcp   (HTTP)"' >> /start.sh && \
    echo 'echo "  - 110/tcp  (POP3)"' >> /start.sh && \
    echo 'echo "  - 143/tcp  (IMAP)"' >> /start.sh && \
    echo 'echo "  - 443/tcp  (HTTPS)"' >> /start.sh && \
    echo 'echo "  - 445/tcp  (SMB)"' >> /start.sh && \
    echo 'echo "  - 3306/tcp (MySQL)"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Filtered Ports (DROP - no response):"' >> /start.sh && \
    echo 'echo "  - 139/tcp  (NetBIOS Session)"' >> /start.sh && \
    echo 'echo "  - 138/udp  (NetBIOS Datagram)"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Rejected Ports (RST response):"' >> /start.sh && \
    echo 'echo "  - 21/tcp   (FTP)"' >> /start.sh && \
    echo 'echo "  - 23/tcp   (Telnet)"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Hint: Use IDS/IPS evasion techniques!"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Keep container running' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh && \
    chmod +x /start.sh

# Expose ports
EXPOSE 22 25 80 110 143 443 445 3306
EXPOSE 21 23 139 3389
EXPOSE 137/udp 138/udp

CMD ["/start.sh"]