-- Create database
CREATE DATABASE IF NOT EXISTS nmap_training CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create database user
CREATE USER IF NOT EXISTS 'nmap_user'@'localhost' IDENTIFIED BY 'nmap_secure_password_2024';
GRANT ALL PRIVILEGES ON nmap_training.* TO 'nmap_user'@'localhost';
FLUSH PRIVILEGES;

USE nmap_training;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User progress table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Flags table (for CTF-style challenges)
CREATE TABLE IF NOT EXISTS flags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id VARCHAR(100) NOT NULL,
    flag_name VARCHAR(255) NOT NULL,
    flag_value VARCHAR(255) UNIQUE NOT NULL,
    points INT DEFAULT 10,
    hint TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_module_id (module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Flag submissions table
CREATE TABLE IF NOT EXISTS flag_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    flag_id INT NOT NULL,
    submitted_flag VARCHAR(255) NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (flag_id) REFERENCES flags(id) ON DELETE CASCADE,
    INDEX idx_user_flag (user_id, flag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample flags for the modules
INSERT INTO flags (module_id, flag_name, flag_value, points, hint) VALUES
('firewall-easy', 'Easy Lab Flag', 'HTB{3asy_f1r3wall_byp4ss}', 10, 'Try basic TCP SYN scan'),
('firewall-medium', 'Medium Lab Flag', 'HTB{m3d1um_1ds_3vas10n}', 20, 'UDP scanning might help'),
('firewall-hard', 'Hard Lab Flag', 'HTB{h4rd_st34lthy_sc4n}', 30, 'Fragment packets and use decoys'),
('host-discovery', 'Discovery Flag', 'HTB{h0st_d1sc0v3ry_m4st3r}', 10, 'Multiple ping techniques'),
('service-enum', 'Service Flag', 'HTB{s3rv1c3_3num3r4t10n}', 15, 'Version detection is key');

-- Create admin user (password: admin123)
INSERT INTO users (name, email, password, created_at) VALUES
('Admin User', 'admin@nmaptraining.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NOW());