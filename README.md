# Kali Linux & Parrot OS Installation Guide

This repository contains automated scripts to install Kali Linux and Parrot OS using either VirtualBox or Docker. Choose the installation method that best suits your needs.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [System Requirements](#system-requirements)
3. [Quick Start](#quick-start)
4. [Using install_kali_parrot_menu.sh](#using-install_kali_parrot_menush)
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

## 🎯 Justificación de Modalidades de Instalación

Este proyecto implementa dos modalidades diferentes de instalación para cumplir con los objetivos educativos del curso:

### Por Qué VirtualBox para Kali Linux

**Justificación:**
- ✅ **Interfaz Gráfica Completa:** Kali Linux requiere acceso a herramientas GUI para demostrar y enseñar de manera visual
- ✅ **Entorno Aislado:** VirtualBox proporciona aislamiento completo del sistema anfitrión
- ✅ **Snapshots:** Permite crear puntos de control antes de temas prácticos delicados
- ✅ **Persistencia:** Los cambios permanecen entre sesiones, ideal para laboratorios multiday
- ✅ **Acceso Completo:** Control total del SO incluido red, permisos, kernels

**Casos de uso:**
- Presentaciones interactivas de herramientas de penetración
- Laboratorios prácticos extensos
- Demostraciones de escritorio y GUI tools

### Por Qué Docker para Parrot OS

**Justificación:**
- ✅ **Ligero:** Perfecto para demostrar herramientas CLI sin overhead del hypervisor
- ✅ **Portabilidad:** Funciona igual en cualquier máquina con Docker
- ✅ **Reproducibilidad:** Garantiza que todos tengan el mismo entorno exacto
- ✅ **Eficiencia de Recursos:** Usa menos CPU, RAM y disco que VirtualBox
- ✅ **Rápido Deployment:** Pronto acceso a herramientas para demostraciones rápidas
- ✅ **Escalabilidad:** Fácil crear múltiples instancias para laboratorios

**Casos de uso:**
- Demostraciones CLI rápidas
- Herramientas de línea de comandos específicas
- Laboratorios cortos y pruebas de conceptos
- Ejercicios de scripting y automatización

### Comparación de Modalidades

| Aspecto | VirtualBox (Kali) | Docker (Parrot) |
|--------|------------------|-----------------|
| **Curva de Aprendizaje** | Baja | Media |
| **Recursos Necesarios** | Altos | Bajos |
| **Tiempo Startup** | 30-60 seg | 1-2 seg |
| **Interfaz** | GUI Completo | CLI |
| **Persistencia** | Automática | Configurable |
| **Aislamiento** | Total | Total |
| **Ideal para** | Cursos extensos | Demostraciones CLI |

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

## 📚 Documentación Detallada del Proceso de Instalación

### Flujo de Instalación Completo

```
┌─────────────────────────────────┐
│ Ejecutar menu script             │
│ ./install_kali_parrot_menu.sh   │
└────────────┬────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
┌──────────┐  ┌──────────────┐
│  Opción  │  │   Opción 2   │
│1-Vbox   │  │  Docker      │
└────┬─────┘  └────┬─────────┘
     │             │
     ▼             ▼
┌─────────────────────────────┐
│ Verificar dependencias      │
│ - VirtualBox / Docker        │
└────────┬────────────────────┘
         │
    ┌────┴────┐
    │No       │Yes
    ▼         ▼
┌────────┐ ┌────────────────────┐
│Install │ │ Descargar imagen   │
│Tools   │ │ (~6GB o ~1GB)      │
└────┬───┘ └────────┬───────────┘
     │              │
     └──────┬───────┘
            │
            ▼
   ┌──────────────────┐
   │ Configurar SO    │
   │ - Drivers        │
   │ - Red           │
   │ - Permisos      │
   └──────┬───────────┘
          │
          ▼
   ┌──────────────────┐
   │ ✓ Instalación   │
   │   Completada     │
   └──────────────────┘
```

### Proceso Paso a Paso - VirtualBox (Kali Linux)

**Tiempo estimado:** 15-30 minutos (depende del ancho de banda)

1. **Verificación de Dependencias**
   - Revisa si VirtualBox está instalado
   - Si no, instala VirtualBox y extensiones

2. **Descarga de Imagen** (~6GB)
   - Descarga imagen oficial desde cdimage.kali.org
   - Valida integridad del archivo

3. **Importación a VirtualBox**
   - Extrae archivo .7z
   - Importa imagen .vbox
   - Registra VM en VirtualBox

4. **Configuración Inicial**
   - Establece memoria RAM
   - Configura CPUs asignadas
   - Configura red (NAT o Bridged)

5. **Inicio y Acceso**
   - Inicia máquina virtual
   - Usuario/Contraseña por defecto: `kali`/`kali`

### Proceso Paso a Paso - Docker (Parrot OS)

**Tiempo estimado:** 3-10 minutos

1. **Verificación de Dependencias**
   - Revisa si Docker está instalado
   - Si no, instala Docker y configura permisos

2. **Descarga de Imagen** (~1GB)
   - Intenta descargar `parrotsec/security`
   - Si falla, fallback a `parrot:latest`

3. **Nmap Pre-instalación**
   - Ejecuta container temporal
   - Instala Nmap en la imagen
   - Confierte en imagen de trabajo

4. **Inicio del Container**
   - Crea container interactivo
   - Proporciona acceso bash

---

## 🛠️ Herramientas Disponibles por Instalación

### Kali Linux (VirtualBox)

**Herramientas de Información Gathering:**
```bash
nmap              # Port scanning
whois             # Domain information
dig               # DNS queries
curl/wget         # Web requests
```

**Herramientas de Análisis:**
```bash
wireshark         # Network packet analysis
tcpdump           # Packet capture
burpsuite         # Web application testing
metasploit        # Exploitation framework
aircrack-ng       # WiFi security
```

**Acceso completo a más de 600 herramientas preinstaladas**

### Parrot OS (Docker)

**Herramientas CLI Optimizadas:**
```bash
nmap              # Port scanning
curl              # HTTP requests
git               # Version control
apache2/nginx     # Web servers
```

**Instalable bajo demanda:**
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
/home/ervin/Desktop/kali/
├── README.md                          # This file
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

## 🎓 Casos de Uso Educativos

### Para Exposiciones con Kali Linux (VirtualBox)

**Tema: Reconocimiento de Red**
```bash
# Demostración de nmap con GUI
nmap -sV target-host
netstat -tuln  # Ver conexiones establecidas
```

**Tema: Análisis de Tráfico**
```bash
# Wireshark - Captura visual de paquetes
wireshark &

# O tcpdump en terminal
sudo tcpdump -i eth0 -w capture.pcap
```

**Tema: Evaluación de Aplicaciones Web**
```bash
# Burp Suite - Análisis interactivo
burp &

# O usar curl desde terminal
curl -X GET http://target.com
```

### Para Exposiciones con Parrot OS (Docker)

**Tema: Automatización de Scanning**
```bash
# Ejecutar escaneos desde Docker
sudo docker run -it parrotsec/security bash
nmap -p- -sV target-host > scan-results.txt
```

**Tema: Pentesting CLI-based**
```bash
# Ejercicios de línea de comandos
apt-get update
apt-get install -y metasploit-framework

# Iniciar MSF
msfconsole
```

**Tema: Scripting y Automatización**
```bash
# Desarrollar scripts personalizados
cat > test-script.sh << 'EOF'
#!/bin/bash
for port in {20..25}; do
    nc -zv target $port
done
EOF
chmod +x test-script.sh
./test-script.sh
```

### Flujo de Clase Sugerido

**Día 1-3: Conceptos Básicos → Kali (VirtualBox)**
- Interfaz visual
- Herramientas con GUI
- Exámenes interactivos

**Día 4-7: Herramientas Avanzadas → Parrot (Docker)**
- Demostraciones CLI rápidas
- Scripting y automatización
- Laboratorios de escalabilidad

---

## 📋 Checklist de Configuración

### Antes de Exposición (Kali Linux)

- [ ] VM iniciada y probada
- [ ] Contraseña cambiada (`passwd`)
- [ ] Sistema actualizado (`apt-get update && upgrade`)
- [ ] Herramientas requeridas instaladas
- [ ] Red configurada (NAT o Bridged según necesidad)
- [ ] Snapshots creados como backup
- [ ] Demostración practicada

### Antes de Exposición (Parrot OS)

- [ ] Docker corriendo (`docker ps`)
- [ ] Imagen descargada correctamente
- [ ] Container conectado a la red
- [ ] Herramientas CLI instaladas
- [ ] Scripts de demostración preparados
- [ ] Conexión a internet verificada

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

## 📌 Resumen Ejecutivo para Profesores

Este proyecto automatiza la instalación de dos sistemas operativos de pentesting utilizando estrategias complementarias:

- **Kali Linux (VirtualBox):** Para exposiciones que requieren interfaz gráfica, herramientas complejas, y un entorno persistente para laboratorios
- **Parrot OS (Docker):** Para demostraciones rápidas, enseñanza de CLI, y ejercicios de automatización

Ambas instalaciones se documentan completamente en este README, justificando la elección de modalidad y proporcionando guías paso a paso.
