# Vulnerable Application Setup Guide

## Supported Environments

- ✅ **Kali Linux** (VirtualBox) - Direct Python execution
- ✅ **Parrot OS** (Docker) - Containerized execution
- ✅ **Generic Linux** - Python-based execution

---

## 🚀 OPTION 1: KALI LINUX (VirtualBox) - SIMPLEST

### A. Using the Universal Script (Recommended)

```bash
cd /home/ervin/Desktop/kali

# Run the universal launcher
./start-vulnerable-app.sh

# The script will:
# 1. Detect environment (Kali)
# 2. Check Python3 installation
# 3. Show scanning instructions
# 4. Start the vulnerable app
```

**Expected Output:**
```
╔════════════════════════════════════════════════════════════╗
║  VULNERABLE APPLICATION - UNIVERSAL LAUNCHER              ║
║  Network Reconnaissance Training (Nmap PoC)               ║
╚════════════════════════════════════════════════════════════╝

ℹ Detecting environment...
→ Environment: KALI

✓ Python3 found: Python 3.x.x
✓ vulnerable-app.py found

[Scanning Instructions Displayed]

Press ENTER to start the vulnerable application...
```

### B. Using Makefile (Alternative)

```bash
cd /home/ervin/Desktop/kali

# Check available targets
make help

# Run vulnerable app
make kali-run

# Or test it
make kali-test
```

### C. Direct Python Execution

```bash
cd /home/ervin/Desktop/kali

python3 vulnerable-app.py
```

### Test in Kali Linux

**Terminal 1** (keep running):
```bash
./start-vulnerable-app.sh
```

**Terminal 2** (new terminal):
```bash
# Wait 2 seconds
sleep 2

# Quick scan
nmap -sV localhost

# Aggressive scan
sudo nmap -A localhost

# Vulnerability detection
nmap --script vuln localhost
```

---

## 🐳 OPTION 2: DOCKER (Parrot OS) - CONTAINERIZED

### A. Quick Start with docker-compose (Recommended)

**Prerequisites:**
```bash
# Install Docker and docker-compose
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Or use the Makefile
make install-deps
```

**Execute:**
```bash
cd /home/ervin/Desktop/kali

# Build and run
make docker-build
make docker-up

# View logs
make docker-logs

# Stop
make docker-down
```

### B. Using docker-compose Directly

```bash
cd /home/ervin/Desktop/kali

# Start services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### C. Manual Docker Build & Run

```bash
cd /home/ervin/Desktop/kali

# Build image
docker build -t vulnerable-app:latest .

# Run container
docker run -d \
  --name vulnerable-app \
  -p 8080:8080 \
  -p 2222:2222 \
  -p 2121:2121 \
  -p 2323:2323 \
  -p 2525:2525 \
  vulnerable-app:latest

# Check logs
docker logs -f vulnerable-app

# Stop
docker stop vulnerable-app
docker rm vulnerable-app
```

### Test in Parrot OS (Docker)

**Terminal 1** (start the app):
```bash
cd /home/ervin/Desktop/kali
make docker-up
```

**Terminal 2** (scan from Parrot container):
```bash
# Option A: From host machine
sudo docker run -it --network host parrotsec/security bash
# Inside container:
nmap -sV 127.0.0.1

# Option B: Using docker-compose
sudo docker-compose exec vulnerable-app nmap -sV 127.0.0.1
```

**Terminal 3** (scan with nmap locally if installed):
```bash
nmap -sV localhost
```

---

## 📋 Scanning Commands Reference

### For Both Kali and Docker

```bash
# ===== BASIC DISCOVERY =====
nmap localhost
nmap -sn localhost          # Host discovery only

# ===== SERVICE DETECTION =====
nmap -sV localhost          # Identify services + versions
nmap -p 8080 localhost      # Specific port
nmap -p 8080,2222 localhost # Multiple ports

# ===== AGGRESSIVE SCAN =====
sudo nmap -A localhost      # Full scan (requires root)

# ===== VULNERABILITY DETECTION =====
nmap --script vuln localhost                    # Vulnerability scripts
nmap --script http-* -p 8080 localhost          # HTTP-specific scripts
nmap --script ssh-* -p 2222 localhost           # SSH-specific scripts

# ===== OUTPUT FORMATS =====
nmap -sV localhost -oN results.txt              # Normal
nmap -sV localhost -oX results.xml              # XML
nmap -sV localhost -oA results                  # All formats

# ===== TIMING TEMPLATES =====
nmap -T1 localhost          # Paranoid (very slow)
nmap -T4 localhost          # Aggressive (fast)

# ===== VERBOSE OUTPUT =====
nmap -vv localhost          # Extra verbose
nmap -vvv localhost         # Maximum verbosity
```

---

## 🔧 Troubleshooting

### Problem: "Port already in use"

**Kali Linux:**
```bash
# Check what's using the port
sudo lsof -i :8080

# Kill the process
sudo kill -9 <PID>
```

**Docker:**
```bash
# Stop all containers
docker stop $(docker ps -aq)

# Or specific container
docker stop vulnerable-app
```

### Problem: "Python3 not installed"

**Kali Linux:**
```bash
sudo apt-get update
sudo apt-get install -y python3
```

**Docker/Parrot:**
```bash
apt-get update
apt-get install -y python3
```

### Problem: "Nmap not found"

**Kali Linux:**
```bash
sudo apt-get install -y nmap
which nmap
```

**Parrot/Docker:**
```bash
make install-deps
# or
sudo apt-get install -y nmap
```

### Problem: "Permission denied" on scripts

```bash
# Make scripts executable
chmod +x start-vulnerable-app.sh
chmod +x run_vulnerable_app.sh
chmod +x run_docker_vulnerable_app.sh
```

### Problem: Docker container won't start

```bash
# Check logs
docker-compose logs vulnerable-app

# Check if ports are in use
sudo netstat -tlnp | grep -E '8080|2222|2121|2323|2525'

# Clean up old containers
docker ps -a
docker rm <container_id>
```

---

## 🎯 Validating the Setup

### Check Services are Running

```bash
# Using netstat (Linux)
netstat -tlnp

# Using ss (modern)
ss -tlnp

# Using lsof
sudo lsof -i -P -n

# Look for ports: 8080, 2222, 2121, 2323, 2525
```

### Test with curl

```bash
# Test HTTP service
curl -v http://localhost:8080/

# Expected response includes:
# Server: Apache/2.4.1 (Vulnerable)
# X-Powered-By: PHP/5.3.8
```

### Test with telnet

```bash
# Test SSH (2222)
telnet localhost 2222

# Test FTP (2121)
telnet localhost 2121

# Test Telnet (2323)
telnet localhost 2323

# Test SMTP (2525)
telnet localhost 2525

# Exit with Ctrl+]
```

---

## 📊 Expected Nmap Output

### Version Detection Output

```
PORT     STATE SERVICE VERSION
8080/tcp open  http    Apache httpd 2.4.1
2222/tcp open  ssh     OpenSSH 3.9p1
2121/tcp open  ftp     FTP server v2.1.0
2323/tcp open  telnet  Linux telnet
2525/tcp open  smtp    Sendmail 8.11.6
```

### Vulnerability Detection Output

```
8080/tcp open  http
| http-enum:
|   /admin/: 200 - Unprotected admin panel
|   /search: 200 - SQL injection possible
|   /download: 200 - Path traversal possible

2222/tcp open  ssh
| ssh-hostkey: 1024 bits
| ssh2-enum-algos: 
|   kex_algorithms: 
|       diffie-hellman-group1-sha1 (BROKEN)
```

---

## 🎓 What You're Learning

✅ **Network Reconnaissance** - Nmap port scanning  
✅ **Service Identification** - Version detection  
✅ **Vulnerability Assessment** - NSE script usage  
✅ **Cyber Kill Chain** - Reconnaissance phase in action  
✅ **Environment Flexibility** - Kali vs Docker execution  
✅ **Automation** - Makefile and scripts  

---

## 📚 Next Steps

1. **Read Documentation:**
   - [QUICK_START.md](QUICK_START.md) - 5-minute reference
   - [NMAP_DEMONSTRATION.md](NMAP_DEMONSTRATION.md) - Theory & concepts
   - [NMAP_REAL_WORLD_SCENARIO.md](NMAP_REAL_WORLD_SCENARIO.md) - Detailed scenarios

2. **Run Scans:**
   - Start with `nmap -sV localhost`
   - Progress to `sudo nmap -A localhost`
   - Advanced: `nmap --script vuln localhost`

3. **Analyze Results:**
   - Identify service versions
   - Find potential vulnerabilities
   - Check against CVE databases

4. **Learn Defenses:**
   - Update services to latest versions
   - Disable unnecessary services
   - Implement firewalls

---

**Last Updated:** March 6, 2026  
**Status:** Production Ready  
**Tested On:** Kali Linux (VirtualBox), Parrot OS (Docker)
