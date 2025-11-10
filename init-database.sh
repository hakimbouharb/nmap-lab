#!/bin/bash
set -e

echo "Waiting for MySQL to start..."
while ! mysqladmin ping --silent; do
    sleep 1
done

echo "MySQL started. Initializing database..."

# Check if database already exists to avoid re-initialization
if ! mysql -u root -e "USE nmap_training" 2>/dev/null; then
    echo "Creating database and tables..."
    
    mysql -u root << 'MYSQL_SCRIPT'
CREATE DATABASE IF NOT EXISTS nmap_training CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'nmap_user'@'localhost' IDENTIFIED BY 'nmap_password';
GRANT ALL PRIVILEGES ON nmap_training.* TO 'nmap_user'@'localhost';
FLUSH PRIVILEGES;

USE nmap_training;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email)
);

CREATE TABLE IF NOT EXISTS user_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    module_id VARCHAR(100) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    score INT DEFAULT 0,
    flags_found INT DEFAULT 0,
    completed_at TIMESTAMP NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_module (user_id, module_id),
    INDEX idx_user_id (user_id)
);

-- Insert test user (password: password)
INSERT IGNORE INTO users (name, email, password) VALUES 
('Test User', 'test@test.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

MYSQL_SCRIPT

    echo "Database initialized successfully!"
else
    echo "Database already exists, skipping initialization."
fi
