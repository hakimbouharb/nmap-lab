FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install ONLY web application essentials
RUN apt-get update && \
    apt-get install -yq \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    php-json \
    mariadb-server \
    curl \
    && apt-get autoclean \
    && apt-get autoremove -yq \
    && rm -rf /var/lib/apt/lists/*

# Create web application directory structure
RUN mkdir -p /var/www/html/api && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Remove default Apache index file
RUN rm -f /var/www/html/index.html

# Configure Apache
RUN a2enmod rewrite && \
    a2enmod ssl && \
    a2ensite default-ssl && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "ServerTokens Prod" >> /etc/apache2/apache2.conf && \
    echo "ServerSignature Off" >> /etc/apache2/apache2.conf

# Configure PHP session settings
RUN mkdir -p /var/lib/php/sessions && \
    chown -R www-data:www-data /var/lib/php/sessions && \
    chmod -R 700 /var/lib/php/sessions

# Copy database initialization script
COPY init-database.sql /tmp/init-database.sql

# Copy web application files
COPY *.php *.html *.js /var/www/html/
COPY api/ /var/www/html/api/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/ && \
    find /var/www/html -type f -name "*.html" -exec chmod 644 {} \; && \
    find /var/www/html -type f -name "*.php" -exec chmod 644 {} \; && \
    find /var/www/html -type f -name "*.js" -exec chmod 644 {} \;

# Configure MySQL
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "=== Starting Dashboard Container ==="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start MySQL' >> /start.sh && \
    echo 'echo "[+] Starting MySQL..."' >> /start.sh && \
    echo 'service mariadb start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Wait for MySQL' >> /start.sh && \
    echo 'echo "[+] Waiting for MySQL to initialize..."' >> /start.sh && \
    echo 'for i in {1..30}; do' >> /start.sh && \
    echo '    if mysqladmin ping --silent 2>/dev/null; then' >> /start.sh && \
    echo '        echo "[+] MySQL is ready!"' >> /start.sh && \
    echo '        break' >> /start.sh && \
    echo '    fi' >> /start.sh && \
    echo '    sleep 2' >> /start.sh && \
    echo 'done' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Initialize database' >> /start.sh && \
    echo 'if [ -f /tmp/init-database.sql ]; then' >> /start.sh && \
    echo '    echo "[+] Initializing database..."' >> /start.sh && \
    echo '    mysql -u root < /tmp/init-database.sql 2>/dev/null || echo "[!] Database already initialized"' >> /start.sh && \
    echo '    echo "[+] Database ready!"' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "=== Dashboard Ready ==="' >> /start.sh && \
    echo 'echo "✓ Access at: http://localhost:8080/"' >> /start.sh && \
    echo 'echo "✓ Admin: admin@nmaptraining.local / admin123"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start Apache in foreground' >> /start.sh && \
    echo 'echo "[+] Starting Apache web server..."' >> /start.sh && \
    echo 'exec apache2ctl -D FOREGROUND' >> /start.sh && \
    chmod +x /start.sh

# Expose ports
EXPOSE 80 443 3306

CMD ["/start.sh"]