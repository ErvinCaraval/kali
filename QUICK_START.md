# NMAP & Vulnerable App - Quick Start Guide

## 🚀 5-Minute Setup

### Option 1: Linux/Kali (Python Direct)

**Terminal 1:**
```bash
cd /home/ervin/Desktop/kali
./run_vulnerable_app.sh
```

**Terminal 2:**
```bash
# Wait 2 seconds, then run:
nmap -sV localhost
nmap -A localhost
nmap --script vuln localhost
```

### Option 2: Parrot OS (Docker)

**Terminal 1:**
```bash
cd /home/ervin/Desktop/kali
./run_docker_vulnerable_app.sh
# Select option 2 to run
```

**Terminal 2:**
```bash
sudo docker run -it --network host parrotsec/security bash
# Inside container:
nmap -sV 127.0.0.1
```

---

## 📊 Scan Commands Reference

### Discovery Scans
```bash
# Find open ports
nmap localhost

# Find open ports + services
nmap -sV localhost

# Everything (slow)
sudo nmap -A localhost

# Just check if host is up
nmap -sn localhost
```

### Vulnerability Detection
```bash
# Run vulnerability NSE scripts
nmap --script vuln localhost

# HTTP vulnerability checks
nmap --script http-* localhost

# Specific ports
nmap -p 8080 --script vuln localhost
```

### Output Formats
```bash
# Normal output to file
nmap -sV localhost -oN results.txt

# XML format
nmap -sV localhost -oX results.xml

# All formats
nmap -sV localhost -oA results
```

---

## 🎯 What to Look For

### Application Vulnerabilities

| Port | Service | Vulnerability |
|------|---------|----------------|
| 8080 | HTTP | SQL Injection, Path Traversal, No Auth |
| 2222 | SSH | Very old version (2003) |
| 2121 | FTP | Unencrypted, Anonymous possible |
| 2323 | Telnet | Completely unencrypted |
| 2525 | SMTP | Old version, potential exploits |

### Attack Chain
```
1. Scan (nmap)
   ↓
2. Identify Versions (nmap -sV)
   ↓
3. Find Vulnerabilities (--script vuln)
   ↓
4. Search for Exploits (CVE databases)
   ↓
5. Plan Attack (Cyber Kill Chain)
   ↓
6. Execute
```

---

## 📚 Documentation Files

| File | Purpose | Time |
|------|---------|------|
| **README.md** | Complete installation guide | 30 min |
| **NMAP_DEMONSTRATION.md** | What is nmap, how to use it | 20 min |
| **NMAP_REAL_WORLD_SCENARIO.md** | Practical scanning examples | 45 min |
| **This file** | Quick reference | 5 min |

---

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Kill process on port
sudo lsof -i :8080
sudo kill -9 <PID>
```

### Docker Issues
```bash
# Check running containers
docker ps

# Stop container
docker stop <name>

# Remove image
docker rmi vuln-app:latest
```

### No Nmap Output
```bash
# Check if nmap is installed
which nmap

# Install nmap
sudo apt-get install -y nmap
```

---

## 💡 Pro Tips

✅ Open MULTIPLE terminals to see what nmap discovers  
✅ Use `-vv` flag for verbose output: `nmap -vv localhost`  
✅ Save scans for comparison: `nmap -A localhost -oN scan1.txt`  
✅ Check HTTP manually: `curl -v http://localhost:8080/admin`  
✅ Read the documentation - it's comprehensive!  

---

## 🎓 Key Learning Outcomes

After this lab, you should understand:

- [ ] How nmap discovers services
- [ ] How version detection works
- [ ] What vulnerabilities look like in practice
- [ ] How reconnaissance fits in Cyber Kill Chain
- [ ] Difference between Kali and Parrot for scanning
- [ ] How to interpret nmap output
- [ ] Basic exploitation concepts

---

**Next Steps:** Read [NMAP_REAL_WORLD_SCENARIO.md](NMAP_REAL_WORLD_SCENARIO.md) for detailed scenarios!
