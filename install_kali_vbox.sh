#!/bin/bash
# install_kali_vbox.sh - Install and configure Kali Linux in VirtualBox

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
URL="https://cdimage.kali.org/kali-2025.4/kali-linux-2025.4-virtualbox-amd64.7z"
FILE="kali-linux-2025.4-virtualbox-amd64.7z"
REQUIRED_SPACE_GB=20

# Functions
print_header() {
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===============================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_dependencies() {
    print_header "Checking Dependencies"
    
    # Check for wget
    if ! command -v wget &> /dev/null; then
        print_info "Installing wget..."
        sudo apt-get update && sudo apt-get install -y wget
    fi
    print_success "wget is available"
    
    # Check for VirtualBox
    if ! command -v VBoxManage &> /dev/null; then
        print_info "Installing VirtualBox..."
        sudo apt-get update && sudo apt-get install -y virtualbox virtualbox-dkms
    fi
    print_success "VirtualBox is installed"
    
    # Check for 7z
    if ! command -v 7z &> /dev/null; then
        print_info "Installing p7zip-full..."
        sudo apt-get update && sudo apt-get install -y p7zip-full
    fi
    print_success "7zip is available"
}

check_disk_space() {
    print_header "Checking Disk Space"
    
    AVAILABLE_SPACE=$(df . | awk 'NR==2 {print int($4/1024/1024)}')
    
    if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE_GB" ]; then
        print_error "Insufficient disk space. Required: ${REQUIRED_SPACE_GB}GB, Available: ${AVAILABLE_SPACE}GB"
        return 1
    fi
    print_success "Sufficient disk space available: ${AVAILABLE_SPACE}GB"
}

download_image() {
    print_header "Downloading Kali Linux Image"
    
    if [ -f "$FILE" ]; then
        print_info "Image file already exists. Skipping download."
        return 0
    fi
    
    print_info "Downloading from: $URL"
    if wget -c "$URL" -O "$FILE"; then
        print_success "Image downloaded successfully"
    else
        print_error "Failed to download image"
        return 1
    fi
}

extract_image() {
    print_header "Extracting Image"
    
    if [ ! -f "$FILE" ]; then
        print_error "Archive file not found: $FILE"
        return 1
    fi
    
    print_info "Extracting $FILE..."
    if 7z x "$FILE" -y; then
        print_success "Image extracted successfully"
    else
        print_error "Failed to extract image"
        return 1
    fi
}

register_vm() {
    print_header "Registering Virtual Machine"
    
    VBOX_FILE=$(find . -maxdepth 2 -name "*.vbox" | head -n 1)
    
    if [ -z "$VBOX_FILE" ]; then
        print_error "Could not find .vbox file after extraction"
        return 1
    fi
    
    print_info "Found VM configuration: $VBOX_FILE"
    
    # Get the full path
    FULL_PATH=$(cd "$(dirname "$VBOX_FILE")" && pwd)/$(basename "$VBOX_FILE")
    
    # Register the VM
    if VBoxManage registervm "$FULL_PATH"; then
        print_success "Virtual Machine registered successfully"
    else
        print_error "Failed to register VM"
        return 1
    fi
}

show_vm_info() {
    print_header "Virtual Machine Information"
    
    VM_NAME=$(grep 'name=' "$(find . -maxdepth 2 -name "*.vbox" | head -n 1)" | grep -oP '(?<=name=")[^"]*' | head -n 1)
    
    echo -e "${GREEN}VM Name: $VM_NAME${NC}"
    echo -e "${YELLOW}To start the VM, use one of these commands:${NC}"
    echo -e "  VirtualBox GUI: ${BLUE}virtualbox${NC}"
    echo -e "  Command line:   ${BLUE}VBoxManage startvm \"$VM_NAME\" --type gui${NC}"
    echo ""
    echo -e "${YELLOW}To access the VM via SSH after starting:${NC}"
    echo -e "  Default username: ${BLUE}kali${NC}"
    echo -e "  Default password: ${BLUE}kali${NC}"
}

show_nmap_setup() {
    print_header "Nmap Post-Installation Setup"
    
    echo -e "${YELLOW}After starting the VM, follow these steps to install Nmap:${NC}"
    echo ""
    echo -e "${GREEN}1. Open a terminal in the VM${NC}"
    echo ""
    echo -e "${GREEN}2. Update the system:${NC}"
    echo -e "  ${BLUE}sudo apt-get update && sudo apt-get upgrade -y${NC}"
    echo ""
    echo -e "${GREEN}3. Install Nmap:${NC}"
    echo -e "  ${BLUE}sudo apt-get install -y nmap${NC}"
    echo ""
    echo -e "${GREEN}4. Verify Nmap installation:${NC}"
    echo -e "  ${BLUE}nmap --version${NC}"
    echo ""
    echo -e "${YELLOW}Common Nmap Usage Examples:${NC}"
    echo -e "  ${BLUE}nmap -sV localhost${NC}                 # Service version detection"
    echo -e "  ${BLUE}nmap -A localhost${NC}                  # Aggressive scan"
    echo -e "  ${BLUE}nmap -p 1-65535 localhost${NC}          # Scan all ports"
    echo -e "  ${BLUE}nmap -sn 192.168.1.0/24${NC}            # Ping scan (host discovery)"
    echo -e "  ${BLUE}nmap -O localhost${NC}                  # OS detection"
    echo ""
    echo -e "${YELLOW}Optional: Install additional security tools:${NC}"
    echo -e "  ${BLUE}sudo apt-get install -y metasploit-framework wireshark burpsuite${NC}"
}

# Main execution
main() {
    print_header "Kali Linux VirtualBox Installation"
    
    check_dependencies || exit 1
    check_disk_space || exit 1
    download_image || exit 1
    extract_image || exit 1
    register_vm || exit 1
    
    print_header "Installation Complete!"
    show_vm_info
    show_nmap_setup
}

# Run main function
main
