FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install basic services for easy lab
RUN apt-get update && \
    apt-get install -yq \
    apache2 \
    openssh-server \
    vsftpd \
    telnetd \
    iptables \
    netcat-openbsd \
    net-tools \
    procps \
    && apt-get autoclean \
    && apt-get autoremove -yq \
    && rm -rf /var/lib/apt/lists/*

# Create flag file in web root
RUN mkdir -p /var/www/html && \
    echo '<html><body><h1>Easy Lab Target</h1><p>Scan me to find the flag!</p><!-- Flag: HTB{3asy_f1r3wall_byp4ss} --></body></html>' > /var/www/html/index.html && \
    echo 'HTB{3asy_f1r3wall_byp4ss}' > /var/www/html/flag.txt && \
    chown -R www-data:www-data /var/www/html

# Configure Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "ServerTokens Full" >> /etc/apache2/apache2.conf && \
    echo "ServerSignature On" >> /etc/apache2/apache2.conf

# Configure SSH with weak credentials
RUN mkdir -p /var/run/sshd && \
    echo 'root:toor' | chpasswd && \
    useradd -m -s /bin/bash student && \
    echo 'student:student' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configure FTP (vulnerable)
RUN echo 'listen=YES' > /etc/vsftpd.conf && \
    echo 'anonymous_enable=YES' >> /etc/vsftpd.conf && \
    echo 'local_enable=YES' >> /etc/vsftpd.conf && \
    echo 'write_enable=YES' >> /etc/vsftpd.conf && \
    echo 'ftpd_banner=Welcome to Easy Lab FTP' >> /etc/vsftpd.conf

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "=== Starting Easy Lab Container ==="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start services' >> /start.sh && \
    echo 'echo "[+] Starting SSH on port 22..."' >> /start.sh && \
    echo 'service ssh start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "[+] Starting Apache on port 80..."' >> /start.sh && \
    echo 'service apache2 start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Configure iptables - Basic filtering' >> /start.sh && \
    echo 'echo "[+] Configuring firewall rules..."' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# FTP port filtered' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 21 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Telnet port filtered' >> /start.sh && \
    echo 'iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with tcp-reset' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Easy Lab Ready ==="' >> /start.sh && \
    echo 'echo "Target IP: 172.25.0.11"' >> /start.sh && \
    echo 'echo "Difficulty: Easy"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Open Ports:"' >> /start.sh && \
    echo 'echo "  - 22/tcp  (SSH)"' >> /start.sh && \
    echo 'echo "  - 80/tcp  (HTTP)"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Filtered Ports:"' >> /start.sh && \
    echo 'echo "  - 21/tcp  (FTP - rejected)"' >> /start.sh && \
    echo 'echo "  - 23/tcp  (Telnet - rejected)"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Flag Location: Find it by scanning!"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Keep container running' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh && \
    chmod +x /start.sh

# Expose ports
EXPOSE 22 80 21 23

CMD ["/start.sh"]