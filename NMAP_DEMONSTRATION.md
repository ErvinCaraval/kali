# NMAP Demonstration Report

## 📋 Table of Contents

1. [Tool Overview](#tool-overview)
2. [Cyber Kill Chain Classification](#cyber-kill-chain-classification)
3. [Demonstration in Kali Linux (VirtualBox)](#demonstration-in-kali-linux-virtualbox)
4. [Demonstration in Parrot OS (Docker)](#demonstration-in-parrot-os-docker)
5. [Analogous Tools](#analogous-tools)
6. [Comparative Analysis](#comparative-analysis)
7. [Practical Exercises](#practical-exercises)

---

## Tool Overview

### What is Nmap?

**Nmap** (Network Mapper) is a free and open-source network scanning and reconnaissance tool used to discover hosts, services, and network topology.

### Key Features

- **Port Scanning:** Identifies open, closed, and filtered ports
- **Service Detection:** Identifies running services and versions
- **OS Detection:** Determines operating system information
- **Network Mapping:** Creates network topology diagrams
- **Scriptable:** Includes Nmap Scripting Engine (NSE) for custom scans
- **Cross-Platform:** Works on Linux, Windows, macOS

### Use Cases

- Network inventory and asset management
- Security vulnerability identification
- Network troubleshooting
- Compliance and audit verification
- Penetration testing and ethical hacking

---

## Cyber Kill Chain Classification

### Lockheed Martin Cyber Kill Chain Phases

The Cyber Kill Chain defines seven phases of a cyberattack:

```
┌─────────────────────────────────────────────────────────────────┐
│                    CYBER KILL CHAIN PHASES                       │
├─────────────────────────────────────────────────────────────────┤
│ 1. Reconnaissance    → Information gathering about target        │
│ 2. Weaponization    → Development of malware or tools            │
│ 3. Delivery         → Transmission of weapon to target           │
│ 4. Exploitation     → Triggering of malicious code               │
│ 5. Installation     → Installation of backdoor/malware          │
│ 6. Command & Control → Establish remote communication            │
│ 7. Actions on Objects→ Achieve adversary's objectives           │
└─────────────────────────────────────────────────────────────────┘
```

### Nmap Position in Cyber Kill Chain

**Phase: RECONNAISSANCE (Phase 1)**

**Justification:**
- Nmap is primarily used in the first phase of attacks
- Gathers critical information without triggering system compromises
- Identifies potential targets and vulnerabilities
- Defensive use: Monitors for unauthorized scanning activities

**Sub-Activities in Reconnaissance:**
```
RECONNAISSANCE
    ├── Active Scanning
    │   ├── Port Scanning (TCP/UDP)
    │   ├── Service Version Detection
    │   └── OS Detection
    ├── Passive Scanning
    │   ├── DNS Enumeration
    │   └── Network Topology Mapping
    └── Information Gathering
        ├── Service Banner Grabbing
        └── Vulnerability Pre-scanning
```

**Why Reconnaissance is Critical:**
1. **Reduces Attack Surface:** Identifies only relevant targets
2. **Supports Planning:** Helps attackers plan next steps
3. **Minimizes Detection:** Often undetected in early phases
4. **Enables Prioritization:** Focuses on high-value targets

---

## Demonstration in Kali Linux (VirtualBox)

### Environment Setup

**Requirements:**
- Kali Linux VM running via VirtualBox
- Target machine (192.168.1.100 or network range)
- Terminal/Console access

### Installation Verification

```bash
# Check if nmap is installed
which nmap

# Display version
nmap --version

# Expected output:
# Nmap version 7.93 or newer
```

### Basic Scan Examples

#### 1. Simple Host Discovery

```bash
# Scan to check if host is alive
nmap -sn 192.168.1.100

# Output example:
# Starting Nmap 7.93
# Nmap scan report for 192.168.1.100
# Host is up (0.0032s latency)
# MAC Address: 00:0C:29:AB:CD:EF (VMware)
```

#### 2. TCP Port Scanning

```bash
# Scan common ports (TCP)
nmap -sT 192.168.1.100

# Scan specific port
nmap -sT -p 80 192.168.1.100

# Scan port range
nmap -sT -p 1-1000 192.168.1.100

# Expected output:
# PORT    STATE    SERVICE
# 22/tcp  open     ssh
# 80/tcp  open     http
# 443/tcp open     https
```

#### 3. Service Version Detection

```bash
# Detect service versions
nmap -sV 192.168.1.100

# Output example:
# PORT    STATE SERVICE VERSION
# 22/tcp  open  ssh     OpenSSH 7.4
# 80/tcp  open  http    Apache httpd 2.4.6
# 443/tcp open  https   nginx 1.14.0
```

#### 4. Operating System Detection

```bash
# OS detection (requires root privileges)
sudo nmap -O 192.168.1.100

# Output example:
# Running: Linux 3.10, Linux 4.4 - 5.10
# OS CPE: cpe:/o:linux:linux_kernel:4.4
# OS details: Linux 4.4 - 5.10, Ubuntu 16.04
```

#### 5. Aggressive Scan

```bash
# Comprehensive scan with multiple options
sudo nmap -A 192.168.1.100

# Equivalent to:
# -sV (version detection)
# -O (OS detection)
# -sC (default scripts)
# --traceroute
```

#### 6. Network Range Scanning

```bash
# Scan entire subnet
nmap -sn 192.168.1.0/24

# Scan multiple hosts
nmap 192.168.1.1,5,10,20

# Output: List of live hosts on network
```

#### 7. Using Nmap Scripts (NSE)

```bash
# List available scripts
ls /usr/share/nmap/scripts/

# Run specific script
nmap --script ssl-enum-ciphers -p 443 192.168.1.100

# Run all safe scripts
nmap --script safe 192.168.1.100

# Example output: Cipher information, vulnerabilities
```

### Interactive GUI: Zenmap

```bash
# Launch Zenmap (GUI interface for nmap)
sudo zenmap &

# Features:
# - Visual interface
# - Target profile selection
# - Scan result visualization
# - Topology mapping
```

### Kali Linux Advantages for Nmap

✅ Pre-installed and optimized  
✅ Zenmap GUI available  
✅ NSE scripts collection complete  
✅ Perfect for GUI-based demonstrations  
✅ Easy to visualize results  

---

## Demonstration in Parrot OS (Docker)

### Environment Setup

```bash
# Start Parrot Docker container
sudo docker run -it parrotsec/security bash

# Or if using alternative image
sudo docker run -it parrot:latest bash
```

### Installation Verification

```bash
# Inside container - check nmap installation
nmap --version

# If not installed, install it
apt-get update
apt-get install -y nmap

# Verify installation
which nmap
nmap --version
```

### Basic Scan Examples (Docker)

#### 1. Host Discovery in Docker

```bash
# Inside container
nmap -sn 192.168.1.100

# Or scan network from host
sudo docker run -it parrotsec/security nmap -sn 192.168.1.0/24
```

#### 2. Port Scanning from Docker

```bash
# TCP port scan
nmap -sT 192.168.1.100

# UDP port scan (slower)
nmap -sU 192.168.1.100

# Combined TCP + UDP
nmap -sT -sU 192.168.1.100
```

#### 3. Output to File (Persistent)

```bash
# Scan and save output
nmap -sV 192.168.1.100 -oN scan-results.txt

# View results
cat scan-results.txt

# Copy from container to host
sudo docker cp <container_id>:/scan-results.txt ./

# Or mount volume
sudo docker run -v /home/ervin/Desktop/kali:/shared -it parrotsec/security bash
nmap -sV 192.168.1.100 -oN /shared/scan-results.txt
```

#### 4. Automated Scanning Script

```bash
# Create scan script inside container
cat > network-scan.sh << 'EOF'
#!/bin/bash
TARGET=$1
PORTS=$2

echo "Starting network scan on $TARGET"
nmap -sV -sC -p $PORTS $TARGET > scan_${TARGET}_$(date +%Y%m%d_%H%M%S).txt
echo "Scan completed"
EOF

chmod +x network-scan.sh
./network-scan.sh 192.168.1.100 1-100
```

#### 5. Batch Scanning

```bash
# Scan multiple hosts
for host in 192.168.1.{1..254}; do
    nmap -sn $host 2>/dev/null | grep "Host is up" && echo "$host is active"
done
```

### Parrot OS Advantages in Docker

✅ Lightweight and fast startup  
✅ Perfect for CLI-based demonstrations  
✅ Easy to create multiple instances  
✅ Ideal for scripting and automation  
✅ Resource-efficient for batch scans  
✅ Container isolation ensures no conflicts  

---

## Analogous Tools

### Tool Comparison

| Tool | Purpose | OS | Interface | Characteristics |
|------|---------|-----|-----------|-----------------|
| **Nmap** | Network scanning & reconnaissance | Linux/Windows/macOS | CLI/GUI | Most popular, powerful |
| **Zenmap** | Nmap GUI wrapper | Linux/Windows/macOS | GUI | Visual Nmap interface |
| **Masscan** | Ultra-fast port scanner | Linux/Windows/macOS | CLI | Faster than Nmap |
| **Netstat** | Network statistics | All OS | CLI | Built-in, simpler |
| **ss** | Socket statistics | Linux | CLI | Modern alternative to netstat |
| **Angry IP Scanner** | IP address range scanner | All OS | GUI | Simple visual scanning |

### Detailed Comparison

#### Nmap vs Masscan

**Nmap:**
```bash
# Slower but more detailed
nmap -sT -sV 192.168.1.100
# Time: 10-30 seconds for 1000 ports
```

**Masscan:**
```bash
# Ultra-fast port scanning
sudo masscan 192.168.1.100 -p1-65535 --rate=10000
# Time: 5-10 seconds for entire port range
# Install: apt-get install -y masscan
```

#### Nmap vs Netstat

**Nmap (Remote host):**
```bash
# Scan remote host
nmap -sT 192.168.1.100
```

**Netstat (Local connections):**
```bash
# Show local listening ports
netstat -tuln

# Show all connections
netstat -an
```

#### Nmap vs SS Tool

**Nmap:**
```bash
# Remote network scanning
nmap -sV 192.168.1.0/24
```

**SS (Socket Statistics):**
```bash
# Local port information (faster)
ss -tlnp
# t: TCP, l: listening, n: numeric, p: process
```

---

## Comparative Analysis

### Kali Linux (VirtualBox) vs Parrot OS (Docker)

#### Nmap Experience Comparison

```
┌─────────────────────────────────────────────┐
│          NMAP USAGE COMPARISON              │
├─────────────────────────────┬─────────────────┤
│ Aspect                      │ Kali   │ Parrot │
├─────────────────────────────┼────────┼────────┤
│ Installation Time           │ Pre-   │ Manual │
│                             │ loaded │        │
│ Startup Time                │ 30-60s │ 1-2s   │
│ GUI Availability (Zenmap)   │ Yes    │ Limited│
│ CLI Performance             │ Good   │ Better │
│ Resource Usage              │ High   │ Low    │
│ Ideal for Scripting         │ Good   │ Better │
│ Documentation Quality       │ Excellent
│ Debugging Capability        │ Better │ Good   │
│ Network Visibility          │ Full   │ Full   │
└─────────────────────────────┴────────┴────────┘
```

### When to Use Each

**Use Kali Linux (VirtualBox) when:**
- Teaching beginners with visual interfaces
- Need comprehensive GUI tools (Zenmap)
- Performing in-depth penetration testing
- Requiring long-term persistent environment
- Need to pause and snapshot tests

**Use Parrot OS (Docker) when:**
- Performing quick network reconnaissance
- Running automated scanning scripts
- Teaching CLI-based penetration testing
- Need lightweight, rapid deployment
- Performing batch network surveys

---

## Practical Exercises

### Exercise 1: Basic Network Discovery

**Objective:** Identify live hosts on a network

**Kali Linux:**
```bash
# Ping sweep of entire subnet
nmap -sn 192.168.1.0/24

# Save output
nmap -sn 192.168.1.0/24 -oN live-hosts.txt
```

**Parrot OS (Docker):**
```bash
sudo docker run -it parrotsec/security bash
nmap -sn 192.168.1.0/24

# With volume mount for persistent output
sudo docker run -v /home/ervin/Desktop/kali:/shared -it parrotsec/security \
  nmap -sn 192.168.1.0/24 -oN /shared/live-hosts.txt
```

### Exercise 2: Service Enumeration

**Objective:** Identify running services and versions

**Kali Linux:**
```bash
# Detect service versions
nmap -sV -p1-1000 192.168.1.100

# With NSE scripts for vulnerability detection
nmap -sV -sC 192.168.1.100
```

**Parrot OS (Docker):**
```bash
sudo docker run -it parrotsec/security \
  nmap -sV -p1-1000 192.168.1.100
```

### Exercise 3: Comprehensive Scan

**Objective:** Perform aggressive comprehensive scan

**Kali Linux (GUI-assisted):**
```bash
# Launch Zenmap for visual scan
sudo zenmap &

# Then select Intense scan profile
# Or command line:
sudo nmap -A -T4 192.168.1.100
```

**Parrot OS (Automated):**
```bash
# Create automated scan script
cat > comprehensive-scan.sh << 'EOF'
#!/bin/bash
for target in 192.168.1.{1..254}; do
    if nmap -sn $target 2>/dev/null | grep -q "Host is up"; then
        echo "Scanning $target..."
        nmap -A -T4 $target >> full-network-scan.txt
    fi
done
EOF

chmod +x comprehensive-scan.sh
./comprehensive-scan.sh
```

### Exercise 4: Vulnerability Pre-scanning

**Objective:** Identify potential vulnerabilities before exploitation

**Kali Linux:**
```bash
# Run vulnerability detection scripts
nmap --script vuln -p1-1000 192.168.1.100

# Specific vulnerability script
nmap --script ssl-known-key -p 443 192.168.1.100
```

**Parrot OS (Docker):**
```bash
sudo docker run -it parrotsec/security \
  nmap --script vuln -p1-1000 192.168.1.100
```

---

## Key Takeaways

### Nmap in Cyber Kill Chain

1. **Reconnaissance Phase:** Nmap is the primary tool for gathering information
2. **Non-Intrusive:** Doesn't trigger immediate system alerts (depends on configuration)
3. **Information Asymmetry:** Attacker gains knowledge without revealing intent
4. **Defensive Use:** Organizations use it to discover and audit their own networks

### Best Practices

✅ **Always Obtain Authorization** before scanning networks  
✅ **Document All Scans** for audit purposes  
✅ **Use Appropriate Scan Types** to minimize network impact  
✅ **Understand Output Data** for accurate interpretation  
✅ **Combine with Other Tools** for comprehensive reconnaissance  

### Responsible Use

⚠️ **Legal Considerations:**
- Unauthorized network scanning may violate laws (CFAA in USA, equivalent in other countries)
- Always obtain written permission from network owner
- Document authorization and scope
- Respect rules of engagement in authorized tests

---

## References

- **Nmap Official Documentation:** https://nmap.org/
- **Cyber Kill Chain:** Lockheed Martin Cyber Kill Chain Framework
- **NSE Scripts:** https://nmap.org/nsedoc/
- **Penetration Testing Frameworks:** OWASP, NIST

---

**Last Updated:** March 6, 2026  
**Prepared for:** Cybersecurity Course  
**Tool Focus:** Nmap Network Mapper  
**Demonstration Platforms:** Kali Linux (VirtualBox) & Parrot OS (Docker)
