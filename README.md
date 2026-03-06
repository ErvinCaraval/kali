# Kali Linux Installation Guide

This repository contains automated scripts to install Kali Linux using either VirtualBox or Docker. Choose the installation method that best suits your needs.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [System Requirements](#system-requirements)
3. [Quick Start](#quick-start)
4. [Using install_kali_menu.sh](#using-install_kali_menush)
5. [Installation Methods](#installation-methods)
6. [Troubleshooting](#troubleshooting)

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
chmod +x install_kali_menu.sh
chmod +x install_kali_vbox.sh
chmod +x install_kali_docker.sh
```

### Step 3: Run the Menu Script

```bash
./install_kali_menu.sh
```

---

## Using install_kali_menu.sh

### What is install_kali_menu.sh?

The `install_kali_menu.sh` script provides an interactive menu to choose between two installation methods:

1. **VirtualBox** - Full GUI desktop environment
2. **Docker** - Lightweight command-line container
3. **Exit** - Close the menu

### How to Use It

#### Running the Script

```bash
./install_kali_menu.sh
```

#### Interactive Menu

Once you run the script, you'll see:

```
=======================================
      Kali Linux Setup Menu            
=======================================

Please choose an installation method:
1) VirtualBox Image (Full Desktop/GUI)
2) Docker Container (Minimal/CLI Only)
3) Exit

Enter your choice [1-3]:
```

#### Making a Selection

- **Option 1:** Type `1` and press Enter to install Kali Linux in VirtualBox
- **Option 2:** Type `2` and press Enter to install Kali Linux in Docker
- **Option 3:** Type `3` and press Enter to exit the menu

### What Happens After Selection

The menu script automatically:

1. Checks that supporting scripts exist
2. Launches the appropriate installation script
3. The installation script handles all setup and installation

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
- Better for penetration testing workflows

#### Installation Process

1. Installs Docker if not already installed
2. Pulls the official Kali Linux Docker image
3. Creates a working container

#### Starting the Container

After installation:

```bash
docker run -it kalilinux/kali-linux-docker /bin/bash
```

#### Using Docker with Tools

Install specific Kali tools:

```bash
docker run -it kalilinux/kali-linux-docker bash
apt-get update
apt-get install -y metasploit-framework
```

---

## Troubleshooting

### Issue 1: Permission Denied Error

**Problem:** `Permission denied` when running the script

**Solution:**
```bash
chmod +x install_kali_menu.sh
chmod +x install_kali_vbox.sh
chmod +x install_kali_docker.sh
./install_kali_menu.sh
```

---

### Issue 2: Script Not Found Error

**Problem:** `Error: install_kali_vbox.sh not found in the current directory`

**Solution:**
Ensure all three scripts are in the same directory:
```bash
ls -la
# You should see:
# install_kali_menu.sh
# install_kali_vbox.sh
# install_kali_docker.sh
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

⚠️ **Important Security Reminders:**

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
/home/ervin/Desktop/kali-linux/
├── README.md                          # This file
├── install_kali_menu.sh               # Menu selection script
├── install_kali_vbox.sh               # VirtualBox installation
├── install_kali_docker.sh             # Docker installation
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
docker rmi kalilinux/kali-linux-docker
```

### Remove Extracted Files

```bash
rm -rf kali-linux-*.vbox*
rm -f kali-linux-*.7z
```

---

## Support & Resources

- **Official Kali Linux:** https://www.kali.org/
- **VirtualBox Documentation:** https://www.virtualbox.org/wiki/Documentation
- **Docker Documentation:** https://docs.docker.com/
- **Kali Linux Forums:** https://forums.kali.org/
- **GitHub Issues:** Create an issue if you encounter problems

---

## License

These scripts are provided as-is for educational purposes. Kali Linux is available under its own license.

---

## Quick Reference Commands

### Menu Script
```bash
./install_kali_menu.sh
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
docker run -it kalilinux/kali-linux-docker  # Run Kali in Docker
docker stop container-id               # Stop container
```

---

**Last Updated:** March 6, 2026  
**Version:** 1.0  
**Author:** Kali Linux Setup Team
