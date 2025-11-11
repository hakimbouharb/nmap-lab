# 🎯 Nmap Training Platform - Multi-Container Setup

## 📁 Complete Project Structure

```
nmap-training-platform/
│
├── docker-compose.yml              ← Master orchestration file
├── README.md
│
├── main/                           ← Dashboard Container
│   ├── Dockerfile
│   ├── init-database.sql
│   ├── config.php
│   ├── index.html                 (Login/Signup)
│   ├── dashboard.html             
│   ├── modules.js                
│   ├── app.js                    
│   └── api/
│       ├── login.php
│       ├── register.php
│       ├── logout.php
│       ├── progress.php
│       ├── submit-flag.php        
│       └── lab-status.php         
│
├── lab-easy/                       ← Easy Lab Container
│   └── Dockerfile
│
├── lab-medium/                     ← Medium Lab Container
│   └── Dockerfile
│
├── lab-hard/                       ← Hard Lab Container
│   └── Dockerfile
│
└── logs/                           ← Log directory (auto-created)
    └── dashboard/
```

---

## 🚀 Step-by-Step Setup

### **Step 1: Create Directory Structure**

```bash
# Create main project directory
mkdir -p nmap-training-platform
cd nmap-training-platform

# Create subdirectories
mkdir -p main/api
mkdir -p lab-easy
mkdir -p lab-medium
mkdir -p lab-hard
mkdir -p logs/dashboard
```

### **Step 2: Place All Files**

Copy the following files into their respective directories:

#### **Root Directory:**
- `docker-compose.yml` ← Master orchestration file

#### **main/ directory:**
- `Dockerfile` ← Dashboard container
- `init-database.sql` ← From previous conversation
- `config.php` ← From previous conversation
- `index.html` ← Login page (FINAL version)
- `dashboard.html` ← SPA dashboard (to be updated with new structure)
- `modules.js` ← Content for each section (NEW)
- `app.js` ← SPA logic (NEW)

#### **main/api/ directory:**
- `login.php` ← From previous conversation
- `register.php` ← From previous conversation
- `logout.php` ← From previous conversation
- `progress.php` ← From previous conversation
- `submit-flag.php` ← (Need to create)
- `lab-status.php` ← (Need to create)

#### **lab-easy/ directory:**
- `Dockerfile` ← Easy lab container

#### **lab-medium/ directory:**
- `Dockerfile` ← Medium lab container

#### **lab-hard/ directory:**
- `Dockerfile` ← Hard lab container

---

## 🏗️ Build & Run Commands

### **Build All Containers:**

```bash
# Build everything from scratch
docker-compose build --no-cache

# Or build individually
docker-compose build dashboard
docker-compose build lab-easy
docker-compose build lab-medium
docker-compose build lab-hard
```

### **Start All Containers:**

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# View specific container logs
docker-compose logs -f dashboard
docker-compose logs -f lab-easy
```

### **Stop Containers:**

```bash
# Stop all
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### **Manage Individual Labs:**

```bash
# Start only easy lab
docker-compose up -d lab-easy

# Stop medium lab
docker-compose stop lab-medium

# Restart hard lab
docker-compose restart lab-hard
```

---

## 🎯 Container Details

### **1. Dashboard Container**
- **Image Size:** ~250 MB
- **Services:** Apache, PHP, MySQL
- **Ports:** 8080 (HTTP), 8443 (HTTPS), 33306 (MySQL)
- **IP:** 172.30.0.10
- **Purpose:** User interface, authentication, progress tracking

### **2. Easy Lab Container**
- **Image Size:** ~120 MB
- **Services:** SSH, Apache, FTP (filtered), Telnet (rejected)
- **IP:** 172.30.0.11
- **Flag:** `HTB{3asy_f1r3wall_byp4ss}`
- **Difficulty:** Basic port scanning

### **3. Medium Lab Container**
- **Image Size:** ~220 MB
- **Services:** SSH, Apache, SMTP, POP3, IMAP, SMB, MySQL
- **IP:** 172.30.0.12
- **Flag:** `HTB{m3d1um_1ds_3vas10n}`
- **Difficulty:** IDS/IPS evasion required

### **4. Hard Lab Container**
- **Image Size:** ~350 MB
- **Services:** All services + DNS, NTP, SNMP, Redis, mDNS, CUPS
- **IP:** 172.30.0.13
- **Flag:** `HTB{h4rd_st34lthy_sc4n}`
- **Difficulty:** Advanced stealth techniques required

---

## 📊 Service Distribution

| Service | Dashboard | Easy | Medium | Hard |
|---------|-----------|------|--------|------|
| Apache/HTTP | ✅ | ✅ | ✅ | ✅ |
| MySQL | ✅ | ❌ | ✅ | ✅ |
| SSH | ❌ | ✅ | ✅ | ✅ |
| SMTP | ❌ | ❌ | ✅ | ✅ |
| POP3/IMAP | ❌ | ❌ | ✅ | ✅ |
| SMB | ❌ | ❌ | ✅ | ✅ |
| DNS | ❌ | ❌ | ❌ | ✅ |
| NTP | ❌ | ❌ | ❌ | ✅ |
| SNMP | ❌ | ❌ | ❌ | ✅ |
| Redis | ❌ | ❌ | ❌ | ✅ |
| mDNS | ❌ | ❌ | ❌ | ✅ |
| **Total Services** | 2 | 4 | 10 | 15+ |

---

## 🔧 Verification Commands

### **Check Running Containers:**
```bash
docker-compose ps
```

Expected output:
```
NAME               STATUS              PORTS
nmap-dashboard     Up 2 minutes        0.0.0.0:8080->80/tcp
nmap-lab-easy      Up 2 minutes        
nmap-lab-medium    Up 2 minutes        
nmap-lab-hard      Up 2 minutes        
```

### **Test Dashboard:**
```bash
curl http://localhost:8080/
```

### **Test Lab Containers:**
```bash
# From your host machine (or another container)
nmap -sS 172.30.0.11  # Easy lab
nmap -sS 172.30.0.12  # Medium lab
nmap -sS 172.30.0.13  # Hard lab
```

### **Access Container Shells:**
```bash
# Dashboard
docker exec -it nmap-dashboard bash

# Easy Lab
docker exec -it nmap-lab-easy bash

# Medium Lab
docker exec -it nmap-lab-medium bash

# Hard Lab
docker exec -it nmap-lab-hard bash
```

---

## 🌐 Network Architecture

```
                    ┌─────────────────────────────┐
                    │   Host Machine (Your PC)    │
                    │   Port 8080 → Dashboard     │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │  Docker Bridge Network      │
                    │  Subnet: 172.30.0.0/16      │
                    │  Gateway: 172.30.0.1        │
                    └──────────────┬──────────────┘
                                   │
            ┌──────────────────────┼──────────────────────┐
            │                      │                      │
    ┌───────▼────────┐    ┌───────▼────────┐    ┌───────▼────────┐
    │   Dashboard    │    │   Easy Lab     │    │  Medium Lab    │
    │  172.30.0.10   │    │  172.30.0.11   │    │  172.30.0.12   │
    │  (Web + DB)    │    │  (Target 1)    │    │  (Target 2)    │
    └────────────────┘    └────────────────┘    └────────────────┘
                                   │
                          ┌────────▼────────┐
                          │   Hard Lab      │
                          │  172.30.0.13    │
                          │  (Target 3)     │
                          └─────────────────┘
```

---

## 📝 Usage Flow

### **For Students:**

1. **Access Dashboard:** `http://localhost:8080/`
2. **Create Account:** Register with email/password
3. **Login:** Access main dashboard
4. **Complete Theory Modules:** Go through all tutorial sections
5. **Easy Lab:** 
   - Unlock automatically
   - Scan 172.30.0.11
   - Find flag
   - Submit flag to unlock Medium Lab
6. **Medium Lab:**
   - Unlocked after Easy Lab completion
   - Scan 172.30.0.12
   - Use evasion techniques
   - Submit flag to unlock Hard Lab
7. **Hard Lab:**
   - Unlocked after Medium Lab completion
   - Scan 172.30.0.13
   - Use advanced stealth techniques
   - Submit final flag

### **For Administrators:**

```bash
# View all logs
docker-compose logs -f

# Check database
docker exec -it nmap-dashboard mysql -u root -prootpass123 nmap_training

# Reset a lab
docker-compose restart lab-easy

# Update dashboard code
# 1. Edit files in main/
# 2. Rebuild: docker-compose build dashboard
# 3. Restart: docker-compose up -d dashboard

# View student progress
docker exec -it nmap-dashboard mysql -u root -prootpass123 \
  -e "SELECT u.name, COUNT(p.completed) as completed FROM nmap_training.users u LEFT JOIN nmap_training.user_progress p ON u.id = p.user_id WHERE p.completed = 1 GROUP BY u.id;"
```

---

## 🔍 Troubleshooting

### **Problem: Containers won't start**
```bash
# Check logs
docker-compose logs

# Remove and rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### **Problem: Can't access dashboard**
```bash
# Check if port 8080 is available
netstat -tuln | grep 8080

# Check container status
docker-compose ps

# Check Apache logs
docker exec -it nmap-dashboard tail -f /var/log/apache2/error.log
```

### **Problem: Labs not accessible**
```bash
# Check network
docker network inspect nmap-training-platform_training_network

# Test connectivity from dashboard to labs
docker exec -it nmap-dashboard ping 172.30.0.11
docker exec -it nmap-dashboard nmap 172.30.0.11
```

### **Problem: Database errors**
```bash
# Access MySQL
docker exec -it nmap-dashboard mysql -u root -prootpass123

# Check tables
docker exec -it nmap-dashboard mysql -u root -prootpass123 \
  -e "SHOW DATABASES; USE nmap_training; SHOW TABLES;"
```

---

## 📈 Resource Usage

### **Expected RAM Usage:**
- Dashboard: ~200 MB
- Easy Lab: ~100 MB
- Medium Lab: ~180 MB
- Hard Lab: ~300 MB
- **Total:** ~780 MB

### **Expected Disk Usage:**
- Dashboard Image: ~250 MB
- Easy Lab Image: ~120 MB
- Medium Lab Image: ~220 MB
- Hard Lab Image: ~350 MB
- **Total:** ~940 MB

---

## 🎓 Learning Path

```
1. Welcome & Overview              (Theory)
2. Enumeration Basics              (Theory)
3. Introduction to Nmap            (Theory)
4. Host Discovery                  (Theory)
5. Port Scanning                   (Theory)
6. Service Enumeration             (Theory)
7. NSE Scripts                     (Theory)
8. Firewall Evasion                (Theory)
9. Easy Lab                        (Practice) 🔓
10. Medium Lab                     (Practice) 🔒 ← Unlocked by Easy flag
11. Hard Lab                       (Practice) 🔒 ← Unlocked by Medium flag
```

---

## ✅ Ready to Deploy!

Once you have all files in place:

```bash
# One command to rule them all
docker-compose up -d --build

# Access your platform
open http://localhost:8080/
```

**Happy scanning! 🚀**