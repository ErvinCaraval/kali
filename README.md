# Kali Linux & Parrot OS Installation Guide

This repository contains automated scripts to install Kali Linux and Parrot OS using either VirtualBox or Docker. Choose the installation method that best suits your needs.

---

##  Table of Contents

1. [Prerequisites](#prerequisites)
2. [System Requirements](#system-requirements)
3. [Quick Start](#quick-start)
4. [Using install_kali_parrot_menu.sh](#using-install_kali_parrot_menush)
5. [Installation Methods](#installation-methods)
6. [Nmap Tool Documentation](#-available-tools-by-installation)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### 1. Update Your System

Before starting, ensure your system is up to date:

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 2. Install Essential Tools

Install basic dependencies:

```bash
sudo apt-get install -y wget curl git build-essential
```

### 3. Enable Virtualization (for VirtualBox)

Check if virtualization is enabled in BIOS:

```bash
sudo grep -E 'vmx|svm' /proc/cpuinfo
```

If the output is empty, you need to enable virtualization in your BIOS settings.

### 4. Install sudo Privileges

The scripts require `sudo` access. Ensure your user is in the `sudoers` group:

```bash
sudo usermod -aG sudo $USER
```

Then log out and log back in for changes to take effect.

---

## System Requirements

### Minimum Requirements

| Requirement | VirtualBox | Docker |
|-----------|-----------|--------|
| RAM | 4GB (8GB recommended) | 2GB (4GB recommended) |
| Disk Space | 30GB | 5GB |
| CPU Cores | 2 | 1 |
| OS | Linux/Windows/macOS | Linux (native) |

### Recommended Setup

- **OS:** Ubuntu 20.04 LTS or newer
- **RAM:** 16GB+
- **Disk Space:** 50GB+ (for comfortable usage)
- **CPU:** 4+ cores

---

## Quick Start

### Step 1: Clone or Navigate to the Repository

```bash
cd /home/ervin/Desktop/kali-linux
```

### Step 2: Make the Menu Script Executable

```bash
chmod +x install_kali_parrot_menu.sh
chmod +x install_kali_vbox.sh
chmod +x install_parrot_docker.sh
```

### Step 3: Run the Menu Script

```bash
./install_kali_parrot_menu.sh
```

---

## Using install_kali_parrot_menu.sh

### What is install_kali_parrot_menu.sh?

The `install_kali_parrot_menu.sh` script provides an interactive menu to choose between two installation methods:

1. **VirtualBox** - Full GUI desktop environment (Kali Linux)
2. **Docker** - Lightweight command-line container (Parrot OS)
3. **Exit** - Close the menu

### How to Use It

#### Running the Script

```bash
./install_kali_parrot_menu.sh
```

#### Interactive Menu

Once you run the script, you'll see:

```
=======================================
    Kali Linux & Parrot OS Menu         
=======================================

Please choose an installation method:
1) VirtualBox Image (Full Desktop/GUI)
2) Docker Container (Minimal/CLI Only)
3) Exit

Enter your choice [1-3]:
```

#### Making a Selection

- **Option 1:** Type `1` and press Enter to install Kali Linux in VirtualBox
- **Option 2:** Type `2` and press Enter to install Parrot OS in Docker
- **Option 3:** Type `3` and press Enter to exit the menu

### What Happens After Selection

The menu script automatically:

1. Checks that supporting scripts exist
2. Launches the appropriate installation script
3. The installation script handles all setup and installation

---

##  Installation Modality Justification

This project implements two different installation modalities to meet the educational objectives of the course:

### Why VirtualBox for Kali Linux

**Justification:**
-  **Full Graphical Interface:** Kali Linux requires access to GUI tools for visual demonstrations and teaching
-  **Isolated Environment:** VirtualBox provides complete isolation from the host system
-  **Snapshots:** Allows creating checkpoints before sensitive practical topics
-  **Persistence:** Changes remain between sessions, ideal for multi-day labs
-  **Full Access:** Complete OS control including networking, permissions, and kernels

**Use Cases:**
- Interactive presentations of penetration testing tools
- Extended practical labs
- Desktop and GUI tool demonstrations

### Why Docker for Parrot OS

**Justification:**
-  **Lightweight:** Perfect for demonstrating CLI tools without hypervisor overhead
-  **Portability:** Works identically on any machine with Docker
-  **Reproducibility:** Guarantees everyone has the exact same environment
-  **Resource Efficiency:** Uses less CPU, RAM, and disk than VirtualBox
-  **Fast Deployment:** Quick access to tools for rapid demonstrations
-  **Scalability:** Easy to create multiple instances for labs

**Use Cases:**
- Quick CLI demonstrations
- Specific command-line tools
- Short labs and proof-of-concept tests
- Scripting and automation exercises

### Modality Comparison

| Aspect | VirtualBox (Kali) | Docker (Parrot) |
|--------|-------------------|---------------------|
| **Learning Curve** | Low | Medium |
| **Resources Required** | High | Low |
| **Startup Time** | 30-60 sec | 1-2 sec |
| **Interface** | Full GUI | CLI |
| **Persistence** | Automatic | Configurable |
| **Isolation** | Complete | Complete |
| **Ideal for** | Extended Courses | CLI Demonstrations |

---

## Installation Methods

### Method 1: VirtualBox Installation

#### What You Get

- Full GUI desktop environment
- Complete Kali Linux desktop with all tools
- Better for beginners and GUI-based workflows
- Can pause/snapshot the VM

#### Installation Process

1. The script downloads the official Kali Linux VirtualBox image (~6GB)
2. Automatically installs VirtualBox if needed
3. Extracts the image
4. Registers the VM in VirtualBox

#### Starting the VM

After installation, start Kali Linux using:

**Via VirtualBox GUI:**
```bash
virtualbox
```

**Via Command Line:**
```bash
VBoxManage startvm "Kali Linux 2025.4" --type gui
```

#### Default Credentials

- **Username:** `kali`
- **Password:** `kali`

#### Next Steps

1. Update the system:
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

2. Change the default password:
   ```bash
   passwd
   ```

---

### Method 2: Docker Installation

#### What You Get

- Lightweight container environment
- Command-line interface (CLI)
- Faster startup and resource-efficient
- Parrot OS with penetration testing tools pre-installed

#### Installation Process

1. Installs Docker if not already installed
2. Pulls the official Parrot OS Docker image
3. Creates a working container

#### Starting the Container

After installation, the script will automatically pull the correct Parrot image:

```bash
sudo docker run -it parrotsec/security bash
```

Or if using the alternative image:

```bash
sudo docker run -it parrot:latest bash
```

#### Using Docker with Tools

Parrot OS comes with penetration testing tools pre-installed. You can also install additional tools:

```bash
sudo docker run -it parrotsec/security bash
apt-get update
apt-get install -y nmap metasploit-framework
```

**Note:** The script automatically handles image selection. If `parrotsec/security` is unavailable, it will fall back to `parrot:latest`.

---

## Detailed Installation Process Documentation

### Documents Included

- **README.md** - This file with installation and configuration guides
- **NMAP_DEMONSTRATION.md** - Comprehensive nmap tool demonstration, Cyber Kill Chain analysis, and comparative usage across Kali and Parrot

### Complete Installation Flow

```
┌─────────────────────────────────┐
│ Run menu script                  │
│ ./install_kali_parrot_menu.sh   │
└────────────┬────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
┌──────────┐  ┌──────────────┐
│  Option  │  │   Option 2   │
│1-Vbox   │  │  Docker      │
└────┬─────┘  └────┬─────────┘
     │             │
     ▼             ▼
┌─────────────────────────────┐
│ Check dependencies          │
│ - VirtualBox / Docker        │
└────────┬────────────────────┘
         │
    ┌────┴────┐
    │No       │Yes
    ▼         ▼
┌────────┐ ┌────────────────────┐
│Install │ │ Download image     │
│Tools   │ │ (~6GB or ~1GB)     │
└────┬───┘ └────────┬───────────┘
     │              │
     └──────┬───────┘
            │
            ▼
   ┌──────────────────┐
   │ Configure OS     │
   │ - Drivers        │
   │ - Network        │
   │ - Permissions    │
   └──────┬───────────┘
          │
          ▼
   ┌──────────────────┐
   │ ✓ Installation   │
   │   Complete       │
   └──────────────────┘
```

### Step-by-Step Process - VirtualBox (Kali Linux)

**Estimated Time:** 15-30 minutes (depends on bandwidth)

1. **Dependency Check**
   - Checks if VirtualBox is installed
   - If not, installs VirtualBox and extensions

2. **Image Download** (~6GB)
   - Downloads official image from cdimage.kali.org
   - Validates file integrity

3. **VirtualBox Import**
   - Extracts .7z file
   - Imports .vbox image
   - Registers VM in VirtualBox

4. **Initial Configuration**
   - Sets RAM memory
   - Configures assigned CPUs
   - Configures network (NAT or Bridged)

5. **Start and Access**
   - Launches virtual machine
   - Default Username/Password: `kali`/`kali`

### Step-by-Step Process - Docker (Parrot OS)

**Estimated Time:** 3-10 minutes

1. **Dependency Check**
   - Checks if Docker is installed
   - If not, installs Docker and configures permissions

2. **Image Download** (~1GB)
   - Attempts to download `parrotsec/security`
   - Falls back to `parrot:latest` if first fails

3. **Nmap Pre-installation**
   - Runs temporary container
   - Installs Nmap in the image
   - Converts to working image

4. **Container Start**
   - Creates interactive container
   - Provides bash access

---

## Available Tools by Installation

### Nmap Network Reconnaissance Tool

**Primary Tool:** Nmap (Network Mapper) is included in this course for network reconnaissance and is classified in the **Reconnaissance Phase** of the Cyber Kill Chain.

**Comprehensive Documentation:**
See [NMAP_DEMONSTRATION.md](NMAP_DEMONSTRATION.md) for:
- Nmap Cyber Kill Chain classification
- Practical demonstrations in Kali Linux
- Practical demonstrations in Parrot OS Docker
- Analogous tools comparison (Masscan, Netstat, SS, etc.)
- Educational use cases and exercises

### Kali Linux (VirtualBox)

**Information Gathering Tools:**
```bash
nmap              # Port scanning
whois             # Domain information
dig               # DNS queries
curl/wget         # Web requests
```

**Analysis Tools:**
```bash
wireshark         # Network packet analysis
tcpdump           # Packet capture
burpsuite         # Web application testing
metasploit        # Exploitation framework
aircrack-ng       # WiFi security
```

**Complete access to 600+ pre-installed tools**

### Parrot OS (Docker)

**Optimized CLI Tools:**
```bash
nmap              # Port scanning
curl              # HTTP requests
git               # Version control
apache2/nginx     # Web servers
```

**Installable on demand:**
```bash
apt-get install -y metasploit-framework
apt-get install -y burpsuite
apt-get install -y wireshark
```

---

### Issue 1: Permission Denied Error

**Problem:** `Permission denied` when running the script

**Solution:**
```bash
chmod +x install_kali_parrot_menu.sh
chmod +x install_kali_vbox.sh
chmod +x install_parrot_docker.sh
./install_kali_parrot_menu.sh
```

---

### Issue 2: Script Not Found Error

**Problem:** `Error: install_kali_vbox.sh not found in the current directory`

**Solution:**
Ensure all three scripts are in the same directory:
```bash
ls -la
# You should see:
# install_kali_parrot_menu.sh
# install_kali_vbox.sh
# install_parrot_docker.sh
```

---

### Issue 3: Insufficient Disk Space

**Problem:** Installation fails due to lack of disk space

**Solution:**
Check available space:
```bash
df -h
```

Free up space or ensure you have:
- **VirtualBox:** 30GB minimum
- **Docker:** 5GB minimum

---

### Issue 4: VirtualBox Not Working

**Problem:** `VirtualBox not found` or `VBoxManage command not found`

**Solution:**
Manually install VirtualBox:
```bash
sudo apt-get install -y virtualbox virtualbox-dkms
```

Then rebuild kernel modules:
```bash
sudo dkms install virtualbox/6.1
```

---

### Issue 5: Docker Permission Denied

**Problem:** `permission denied while trying to connect to the Docker daemon`

**Solution:**
Add your user to the docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

Then log out and log back in.

---

### Issue 6: Download Failed

**Problem:** Script fails to download the image

**Solution:**
Check your internet connection:
```bash
ping -c 4 8.8.8.8
```

Try manual download:
```bash
wget https://cdimage.kali.org/kali-2025.4/kali-linux-2025.4-virtualbox-amd64.7z
```

---

### Issue 7: Docker Image Not Found

**Problem:** `pull access denied for parrotsec/parrot-security` or similar Docker pull errors

**Solution:**
The script automatically handles image selection. It will try:
1. `parrotsec/security` (primary)
2. `parrot:latest` (fallback)

If both fail, manually search for available images:
```bash
docker search parrot
```

Or manually pull a working image:
```bash
sudo docker pull parrot:latest
```

---

## Advanced Configuration

### Customize VirtualBox VM

After installation, adjust VM settings:

```bash
# Increase allocated RAM to 4GB
VBoxManage modifyvm "Kali Linux 2025.4" --memory 4096

# Increase CPU cores to 2
VBoxManage modifyvm "Kali Linux 2025.4" --cpus 2

# Enable 3D acceleration
VBoxManage modifyvm "Kali Linux 2025.4" --accelerate3d on
```

### Network Configuration

Enable bridged networking for VM:

```bash
VBoxManage modifyvm "Kali Linux 2025.4" --nic1 bridged --bridgeadapter1 eth0
```

---

## Security Notes

  **Important Security Reminders:**

1. **Change Default Password:** Always change the default `kali` password immediately
2. **Keep Updated:** Regularly update Kali Linux:
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```
3. **Use Snapshots:** Create VirtualBox snapshots before testing:
   ```bash
   VBoxManage snapshot "Kali Linux 2025.4" take "backup-name"
   ```
4. **Network Isolation:** Test in isolated networks during penetration tests

---

## File Structure

```
/home/ervin/Desktop/kali/
├── README.md                          # This file - Installation and configuration guide
├── NMAP_DEMONSTRATION.md              # Nmap tool guide, Cyber Kill Chain, demonstrations
├── install_kali_parrot_menu.sh        # Menu selection script
├── install_kali_vbox.sh               # VirtualBox installation (Kali Linux)
├── install_parrot_docker.sh           # Docker installation (Parrot OS)
└── .gitignore                         # (Optional) Git ignore file
```

---

## Uninstallation

### Remove VirtualBox VM

```bash
VBoxManage unregistervm "Kali Linux 2025.4" --delete
```

### Remove Docker Image

```bash
docker rmi parrotsec/security
# Or if using the alternative image:
docker rmi parrot:latest
```

### Remove Extracted Files

```bash
rm -rf kali-linux-*.vbox*
rm -f kali-linux-*.7z
```

---

## Support & Resources

- **Official Kali Linux:** https://www.kali.org/
- **Official Parrot OS:** https://www.parrotsec.org/
- **VirtualBox Documentation:** https://www.virtualbox.org/wiki/Documentation
- **Docker Documentation:** https://docs.docker.com/
- **Kali Linux Forums:** https://forums.kali.org/
- **Parrot OS Forums:** https://community.parrotsec.org/
- **GitHub Issues:** Create an issue if you encounter problems

---

##  Educational Use Cases

### For Presentations with Kali Linux (VirtualBox)

**Topic: Network Reconnaissance**
```bash
# Nmap demonstration with GUI
nmap -sV target-host
netstat -tuln  # View established connections
```

**Topic: Traffic Analysis**
```bash
# Wireshark - Visual packet capture
wireshark &

# Or tcpdump from terminal
sudo tcpdump -i eth0 -w capture.pcap
```

**Topic: Web Application Assessment**
```bash
# Burp Suite - Interactive analysis
burp &

# Or use curl from terminal
curl -X GET http://target.com
```

### For Presentations with Parrot OS (Docker)

**Topic: Scanning Automation**
```bash
# Run scans from Docker
sudo docker run -it parrotsec/security bash
nmap -p- -sV target-host > scan-results.txt
```

**Topic: CLI-based Pentesting**
```bash
# Command-line exercises
apt-get update
apt-get install -y metasploit-framework

# Start MSF
msfconsole
```

**Topic: Scripting and Automation**
```bash
# Develop custom scripts
cat > test-script.sh << 'EOF'
#!/bin/bash
for port in {20..25}; do
    nc -zv target $port
done
EOF
chmod +x test-script.sh
./test-script.sh
```

### Suggested Class Flow

**Day 1-3: Basic Concepts → Kali (VirtualBox)**
- Visual interface
- GUI tools
- Interactive labs

**Day 4-7: Advanced Tools → Parrot (Docker)**
- Quick CLI demonstrations
- Scripting and automation
- Scalability labs

---

##  Nmap Tool Demonstration & Analysis

### Purpose

This course includes **Nmap (Network Mapper)** as the primary network reconnaissance tool. A comprehensive guide is provided to demonstrate its use across both operating systems and classify it within the cybersecurity attack framework.

### What's Included

The [NMAP_DEMONSTRATION.md](NMAP_DEMONSTRATION.md) document provides:

1. **Cyber Kill Chain Classification**
   - Nmap's role in the Reconnaissance phase
   - Attack workflow analysis
   - Defensive perspectives

2. **Practical Demonstrations**
   - Running nmap on Kali Linux (VirtualBox)
   - Running nmap on Parrot OS (Docker)
   - Various scan types and use cases

3. **Analogous Tools Analysis**
   - Masscan (ultra-fast scanning)
   - Netstat (local port inspection)
   - SS Tool (modern socket statistics)
   - Angry IP Scanner (GUI alternative)

4. **Comparative Demonstrations**
   - Performance comparison (Kali vs Docker)
   - When to use each environment
   - Best practices for each OS

5. **Practical Exercises**
   - Network discovery
   - Service enumeration
   - Comprehensive scanning
   - Vulnerability pre-scanning

### Quick Start - Nmap Examples

**Kali Linux:**
```bash
# Simple host discovery
nmap -sn 192.168.1.100

# Service detection
nmap -sV 192.168.1.100

# Aggressive scan with GUI (Zenmap)
sudo zenmap &
```

**Parrot OS (Docker):**
```bash
# Run inside container
sudo docker run -it parrotsec/security bash
nmap -sV 192.168.1.100

# Or directly from host
sudo docker run -it parrotsec/security \
  nmap -sV 192.168.1.100
```

**→ For complete documentation, see [NMAP_DEMONSTRATION.md](NMAP_DEMONSTRATION.md)**

---

##  Configuration Checklist

### Before Presentation (Kali Linux)

- [ ] VM started and tested
- [ ] Password changed (`passwd`)
- [ ] System updated (`apt-get update && upgrade`)
- [ ] Required tools installed
- [ ] Network configured (NAT or Bridged as needed)
- [ ] Snapshots created as backup
- [ ] Presentation practiced

### Before Presentation (Parrot OS)

- [ ] Docker running (`docker ps`)
- [ ] Image downloaded correctly
- [ ] Container connected to network
- [ ] CLI tools installed
- [ ] Demonstration scripts prepared
- [ ] Internet connection verified

---

These scripts are provided as-is for educational purposes. Kali Linux is available under its own license.

---

## Quick Reference Commands

### Menu Script
```bash
./install_kali_parrot_menu.sh
```

### VirtualBox Management
```bash
VBoxManage list vms                    # List all VMs
VBoxManage startvm "VM-name" --type gui  # Start VM with GUI
VBoxManage controlvm "VM-name" poweroff  # Power off VM
VBoxManage snapshot "VM-name" take backup  # Create snapshot
```

### Docker Commands
```bash
docker ps                              # List running containers
docker images                          # List downloaded images
sudo docker run -it parrotsec/security bash  # Run Parrot OS in Docker
sudo docker run -it parrot:latest bash # Alternative Parrot OS image
docker stop container-id               # Stop container
```

---

**Last Updated:** March 6, 2026  
**Version:** 2.0 - Curso Edition  
**Author:** Kali Linux Setup Team

---

##  Executive Summary for Instructors

This project automates the installation of two penetration testing operating systems using complementary strategies:

- **Kali Linux (VirtualBox):** For presentations requiring a graphical interface, complex tools, and a persistent environment for labs
- **Parrot OS (Docker):** For quick demonstrations, CLI teaching, and automation exercises

**Both installations are fully documented in this README, justifying the choice of modality and providing step-by-step guides.**

### Included Documentation

1. **README.md** (this file)
   - Installation procedures for both operating systems
   - System requirements and prerequisites
   - Educational use cases and class flow
   - Configuration checklists

2. **NMAP_DEMONSTRATION.md** (comprehensive tool guide)
   - Network reconnaissance tool demonstration
   - Cyber Kill Chain classification and analysis
   - Practical examples for both Kali and Parrot
   - Comparison with analogous tools
   - Educational exercises


