# NMAP Real-World Scenario: Scanning Vulnerable Application

## Overview

This guide demonstrates **practical real-world scanning** using the vulnerable application (PoC) included in this repository.

**Files:**
- `vulnerable-app.py` - Python application with intentional vulnerabilities
- This document - Step-by-step scanning instructions

---

## What is the Vulnerable Application?

A proof-of-concept application that simulates a real compromised system with:

### Services Running

```
Port 8080   → HTTP Web Server (Apache 2.4.1 with old PHP)
Port 2222   → SSH Service (OpenSSH 3.9p1 - very old)
Port 2121   → FTP Service (FTP v2.1.0)
Port 2323   → Telnet Service (unencrypted protocol)
Port 2525   → SMTP Service (Sendmail 8.11.6)
```

### Intentional Vulnerabilities

1. **Exposed Version Information**
   - Server headers reveal software versions
   - Allows attacker to identify known vulnerabilities

2. **Unprotected Admin Panel**
   - `/admin` endpoint accessible without authentication
   - Exposes database information

3. **SQL Injection Vulnerability**
   - Search functionality doesn't sanitize input
   - Query: `SELECT * FROM products WHERE name LIKE '%{query}%'`

4. **Path Traversal Vulnerability**
   - File download allows `../` sequences
   - Can access `/etc/passwd` or other system files

5. **Outdated Service Versions**
   - SSH version from 2003
   - FTP protocol from 1971 (unencrypted)
   - Telnet from 1969 (unencrypted)

---

## SCENARIO 1: Setting Up the Vulnerable Application

### In Kali Linux (VirtualBox)

**Step 1: Navigate to Project Directory**
```bash
cd /home/ervin/Desktop/kali
```

**Step 2: Run the Vulnerable Application**
```bash
python3 vulnerable-app.py
```

**Expected Output:**
```
============================================================
VULNERABLE APPLICATION - PROOF OF CONCEPT
============================================================
ℹ Educational Cybersecurity Demonstration
ℹ This application intentionally contains vulnerabilities
ℹ for learning purposes only.

Services that will be started:
  - Web Server (HTTP) - Port 8080
  - SSH Service - Port 2222
  - FTP Service - Port 2121
  - Telnet Service - Port 2323
  - SMTP Service - Port 2525

How to scan this application:
  nmap -sV -sC -p 8080,2222,2121,2323,2525 localhost
  nmap -A localhost
  nmap --script vuln localhost

Vulnerabilities to find:
  1. Exposed version information in HTTP headers
  2. Unprotected admin panel (no authentication)
  3. SQL Injection vulnerability in search
  4. Path traversal vulnerability in download
  5. Old/vulnerable service versions (SSH, FTP, SMTP)
  6. Telnet service running (unencrypted)

✓ HTTP Server started on port 8080
✓ Vulnerable SSH Service listening on port 2222
✓ Vulnerable FTP Service listening on port 2121
✓ Vulnerable Telnet Service listening on port 2323
✓ Vulnerable SMTP Service listening on port 2525
✓ All services started successfully!
```

**Keep this terminal running** and open a new terminal for scanning.

### In Parrot OS (Docker)

**Create a shell script to run the app in Docker:**

```bash
# Create container with Python3
sudo docker run -it -p 8080:8080 -p 2222:2222 -p 2121:2121 -p 2323:2323 -p 2525:2525 \
  --name vuln-app parrotsec/security bash
```

**Inside the container:**
```bash
# Install Python3
apt-get update && apt-get install -y python3

# Create the vulnerable app file
cat > vulnerable-app.py << 'ENDFILE'
[Copy content from vulnerable-app.py]
ENDFILE

# Run it
python3 vulnerable-app.py
```

---

## SCENARIO 2: Network Reconnaissance with Nmap

### Initial Discovery Scan

**Objective:** Identify what's running on the target

**Command:**
```bash
nmap -sn 127.0.0.1
```

**Output:**
```
Starting Nmap 7.93 ( https://nmap.org )
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000073s latency).
```

**Analysis:**
- Host responds to ping
- Latency is minimal (local machine)
- Confirms target is reachable

---

## SCENARIO 3: Port Scanning (Reconnaissance Phase)

### Step 1: Quick Port Scan

**Objective:** Find open ports without service detection

**Command:**
```bash
nmap -p- 127.0.0.1
```

**Output:**
```
Starting Nmap 7.93 ( https://nmap.org )
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000069s latency).

PORT     STATE SERVICE
2121/tcp open  ccws-eppc
2222/tcp open  EtherNetIP-1
2323/tcp open  3d-nfsd
2525/tcp open  ms-v-worlds
8080/tcp open  http-proxy

Nmap done at Wed Mar 06 12:34:56 2026; 1 IP address scanned
```

**Analysis:**
- 5 open ports discovered
- Nmap identifies probable services based on port numbers
- Port 8080 is clearly HTTP
- Ports 2222, 2121, 2323, 2525 need further investigation

### Step 2: Service Version Detection

**Objective:** Identify exact software versions running

**Command:**
```bash
nmap -sV -p 8080,2222,2121,2323,2525 127.0.0.1
```

**Output:**
```
Starting Nmap 7.93 ( https://nmap.org )
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000069s latency).

PORT     STATE SERVICE VERSION
2121/tcp open  ftp     FTP server v2.1.0
2222/tcp open  ssh     OpenSSH 3.9p1 Debian-1.0
2323/tcp open  telnet  Linux telnet
2525/tcp open  smtp    Sendmail 8.11.6
8080/tcp open  http    Apache httpd 2.4.1

Nmap done at Wed Mar 06 12:34:57 2026; 1 IP address scanned
```

**Analysis:**
- **OpenSSH 3.9p1**: Released 2003 - VERY OLD, multiple vulnerabilities known
- **Apache 2.4.1**: Released 2012 - Old but not ancient
- **Sendmail 8.11.6**: Released 2001 - Multiple known CVEs
- **Telnet**: Unencrypted protocol - CRITICAL SECURITY ISSUE
- **FTP v2.1.0**: Unencrypted, user credentials sent in plaintext

**This is Reconnaissance Phase - Attacker now knows what software is running and can search for known exploits**

### Step 3: Scripts and Aggressive Scan

**Objective:** Discover additional vulnerabilities and information

**Command:**
```bash
nmap -A -p 8080,2222,2121,2323,2525 127.0.0.1
```

**Output:**
```
Starting Nmap 7.93 ( https://nmap.org )
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000069s latency).

PORT     STATE SERVICE VERSION
2121/tcp open  ftp     FTP server v2.1.0
                |_ftp-anon: Anonymous FTP login possible
2222/tcp open  ssh     OpenSSH 3.9p1 Debian-1.0
                |_ssh-hostkey: 1024 8d:8d:8d:8d:8d:8d:8d:8d
2323/tcp open  telnet  Linux telnet
                |_telnet-encryption: Telnet is running unencrypted
2525/tcp open  smtp    Sendmail 8.11.6
                |_ SMTP: Sendmail 8.11.6
8080/tcp open  http    Apache httpd 2.4.1
                |_ Server header reveals: Apache/2.4.1
                |_ X-Powered-By: PHP/5.3.8
                |_http-robots.txt: 1 entry found

Nmap done at Wed Mar 06 12:34:59 2026; 1 IP address scanned
```

**Key Findings:**
1. **FTP Anonymous Login**: Can login without credentials
2. **SSH Host Key**: Can be used for SSH hijacking identification
3. **Telnet Unencrypted**: Traffic in plaintext
4. **PHP 5.3.8**: From 2011, multiple security issues
5. **robots.txt**: Reveals information about application structure

---

## SCENARIO 4: HTTP Vulnerability Scanning

### Detailed Web Application Scanning

**Objective:** Identify web application vulnerabilities

**Command:**
```bash
nmap --script http-enum -p 8080 127.0.0.1
```

**Output:**
```
8080/tcp open  http
| http-enum:
|   /admin/: 200 - Unprotected admin panel
|   /search: 200 - Potential SQL injection vector
|   /download: 200 - Path traversal possible
|_  /index.html: 200
```

### Manual Web Exploration

**Check for vulnerabilities using curl:**

```bash
# Get HTTP headers (reveals versions)
curl -I http://localhost:8080/

# Output shows:
# Server: Apache/2.4.1 (Vulnerable)
# X-Powered-By: PHP/5.3.8
```

**Access unprotected admin panel:**
```bash
curl http://localhost:8080/admin
```

**Output:**
```
<h1>Admin Panel - UNPROTECTED</h1>
<p>Database: webapp_db</p>
<p>Users: admin, user1, user2</p>
<p>Passwords: stored in users table</p>
```

**Test SQL injection:**
```bash
curl "http://localhost:8080/search?q=test' OR '1'='1"
```

**Test path traversal:**
```bash
curl "http://localhost:8080/download?file=../../etc/passwd"
```

---

## SCENARIO 5: Nmap Scripts for Vulnerability Detection

### Vulnerability Scanning

**Objective:** Run NSE (Nmap Scripting Engine) scripts to detect known vulnerabilities

**Command:**
```bash
nmap --script vuln -p 8080,2222 127.0.0.1
```

**Output Example:**
```
2222/tcp open  ssh
| ssh-hostkey:
|   1024 8d:8d:8d:8d:8d:8d:8d:8d (RSA)
|_  ssh-rsa AAAAB3Nza...
| ssh2-enum-algos:
|   kex_algorithms: (5)
|       diffie-hellman-group1-sha1 (BROKEN)
|_      diffie-hellman-group14-sha1 (BROKEN)

8080/tcp open  http
| http-vuln-cve2021-xxxxx: VULNERABLE
| Apache 2.4.1 has known CVE vulnerabilities
```

---

## SCENARIO 6: Mapping Attack Surface

### Complete Reconnaissance Report

**Command:**
```bash
nmap -sV --script default,vuln -oN reconnaissance-report.txt 127.0.0.1
```

**Analysis Summary:**

```
ATTACK SURFACE MAPPING
====================

1. NETWORK LAYER
   - Host: 127.0.0.1
   - Reachability: UP
   - Latency: Minimal

2. SERVICE LAYER
   Port 2121 - FTP v2.1.0 (UNENCRYPTED)
   ├─ Vulnerability: Anonymous login possible
   ├─ Risk: Read/Write access without authentication
   └─ Impact: Data theft, malware distribution

   Port 2222 - SSH (OLD VERSION 3.9p1)
   ├─ Released: 2003 (23 years old)
   ├─ Known CVEs: 10+ critical vulnerabilities
   └─ Impact: Potential remote code execution

   Port 2323 - Telnet (UNENCRYPTED)
   ├─ Vulnerability: Credentials sent in plaintext
   ├─ Risk: Credential sniffing
   └─ Impact: System compromise

   Port 2525 - SMTP (Sendmail 8.11.6)
   ├─ Released: 2001 (25 years old)
   ├─ Known CVEs: Multiple remote execution vulns
   └─ Impact: Email spoofing, server compromise

   Port 8080 - HTTP (Apache + PHP 5.3.8)
   ├─ Vulnerability 1: SQL Injection in /search
   ├─ Vulnerability 2: Path Traversal in /download
   ├─ Vulnerability 3: No authentication on /admin
   └─ Impact: Database compromise, information disclosure

3. EXPLOITABILITY RANKING
   🔴 CRITICAL: Telnet + FTP unencrypted
   🔴 CRITICAL: OpenSSH 3.9p1 (ancient version)
   🔴 CRITICAL: SQL Injection + No auth admin
   🟠 HIGH: Sendmail 8.11.6
   🟡 MEDIUM: Path traversal vulnerability

4. CYBER KILL CHAIN MAPPING
   Phase: RECONNAISSANCE (Current - What we're doing now)
   ├─ Identify hosts: ✓ Done
   ├─ Identify services: ✓ Done
   ├─ Identify versions: ✓ Done
   ├─ Identify vulnerabilities: ✓ Done (via Nmap scripts)
   └─ Next phase would be: WEAPONIZATION
        ├─ Search for exploits for old SSH
        ├─ Prepare SQL injection payloads
        ├─ Create FTP credential extraction tools
        └─ Develop HTTP attack vectors
```

---

## SCENARIO 7: Comparison - Before and After Hardening

### What Nmap Shows (Vulnerable System)

```
nmap -sV localhost
PORT     STATE SERVICE VERSION
2121/tcp open  ftp     FTP server v2.1.0
2222/tcp open  ssh     OpenSSH 3.9p1 Debian-1.0
2323/tcp open  telnet  Linux telnet
2525/tcp open  smtp    Sendmail 8.11.6
8080/tcp open  http    Apache httpd 2.4.1
```

### What Would Change After Hardening

```
nmap -sV localhost
PORT     STATE    SERVICE      VERSION
2121/tcp filtered ftp          (no version available)
2222/tcp open     ssh          OpenSSH 8.9p1 (latest)
2323/tcp filtered telnet       (service disabled)
2525/tcp filtered smtp         (rate limited)
8080/tcp open     http         Apache httpd 2.4.54 (latest)

Changes:
- SSH: Updated to latest version with patches
- Telnet: Disabled completely
- FTP: Filtered/blocked by firewall
- SMTP: Rate-limited, port filtering
- HTTP: Latest Apache version, security headers added
- All services: Reduced version disclosure
```

---

## Exercises

### Exercise 1: Information Gathering
```bash
# What information can you gather from the vulnerable app?
nmap -sV -O localhost

# Answer: Operating system, service versions, and potential exploits
```

### Exercise 2: Vulnerability Prioritization
```bash
# Which vulnerabilities are most critical?
# Hint: Use nmap --script vuln
# Think about: Confidentiality, Integrity, Availability (CIA)
```

### Exercise 3: Defense Planning
```bash
# Based on nmap results, what mitigations would you implement?
# Create a hardening checklist
```

---

## Real-World Implications

### As an Attacker
1. **Information Gathered**: Service versions, open ports, web endpoints
2. **Next Steps**: Search for known exploits, craft payloads
3. **Time to Compromise**: Could be minutes to hours with this information
4. **Attack Path**: Likely start with SQL injection or FTP access

### As a Defender
1. **What You See**: Nmap reveals your entire attack surface
2. **Action Items**: Update services, firewall ports, disable unnecessary services
3. **Continuous Monitoring**: Regular nmap scans to verify no new vulnerabilities
4. **Baseline**: Establish what "normal" looks like

---

## Key Takeaways

✅ **Reconnaissance is Critical** - Nmap automates the discovery process
✅ **Version Information = Exploitability** - Old software = known vulnerabilities
✅ **Defense in Depth** - A single vulnerability chain leads to compromise
✅ **Monitoring Matters** - Regular scans reveal the attack surface
✅ **Cyber Kill Chain** - Reconnaissance phase determines feasibility of attack

---

## References

- Vulnerable App: `vulnerable-app.py` in this repository
- Nmap Documentation: https://nmap.org/
- CVE Database: https://nvd.nist.gov/
- Cyber Kill Chain: Lockheed Martin Threat Model

---

**Last Updated:** March 6, 2026  
**Purpose:** Practical demonstration of network reconnaissance  
**Target Audience:** Cybersecurity students and professionals
