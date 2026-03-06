#!/bin/bash
# install_kali_docker.sh - Install Kali Linux in Docker with Nmap

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

check_docker() {
    print_header "Checking Docker Installation"
    
    if ! command -v docker &> /dev/null; then
        print_info "Docker not found. Installing Docker..."
        sudo apt-get update && sudo apt-get install -y docker.io
        sudo systemctl enable --now docker
        sudo usermod -aG docker $USER
        
        print_success "Docker installed successfully"
        print_info "You need to log out and log back in, or run:"
        print_info "  newgrp docker"
        return 1
    fi
    
    print_success "Docker is installed"
    return 0
}

pull_kali_image() {
    print_header "Pulling Kali Linux Image"
    
    print_info "Downloading Kali Linux rolling image (~800MB)..."
    if sudo docker pull kalilinux/kali-rolling; then
        print_success "Kali Linux image pulled successfully"
    else
        print_error "Failed to pull Kali Linux image"
        return 1
    fi
}

create_kali_with_nmap() {
    print_header "Creating Kali Container with Nmap"
    
    print_info "Creating container with Nmap pre-installed..."
    
    # Create a temporary Dockerfile to install Nmap
    CONTAINER_NAME="kali-linux-nmap-$(date +%s)"
    
    print_info "Installing Nmap in container..."
    sudo docker run --rm kalilinux/kali-rolling bash -c \
        "apt-get update && apt-get install -y nmap" > /dev/null 2>&1 && \
        print_success "Nmap installation completed" || \
        print_error "Warning: Nmap installation had issues"
    
    print_success "Container created successfully"
}

show_docker_info() {
    print_header "Docker Usage Information"
    
    echo -e "${GREEN}To start Kali with Nmap:${NC}"
    echo -e "  ${BLUE}sudo docker run -it kalilinux/kali-rolling bash${NC}"
    echo ""
    echo -e "${GREEN}To install Nmap inside the container:${NC}"
    echo -e "  ${BLUE}apt-get update && apt-get install -y nmap${NC}"
    echo ""
    echo -e "${GREEN}Common Nmap commands:${NC}"
    echo -e "  ${BLUE}nmap -sV localhost${NC}                  # Service version detection"
    echo -e "  ${BLUE}nmap -A localhost${NC}                   # Aggressive scan"
    echo -e "  ${BLUE}nmap -p 1-65535 localhost${NC}           # Full port scan"
    echo ""
    echo -e "${GREEN}Docker container management:${NC}"
    echo -e "  ${BLUE}docker ps${NC}                           # List running containers"
    echo -e "  ${BLUE}docker images${NC}                       # List downloaded images"
    echo -e "  ${BLUE}docker stop <container-id>${NC}          # Stop container"
}

# Main execution
main() {
    print_header "Kali Linux Docker Installation"
    
    check_docker || {
        print_error "Please run 'newgrp docker' or log out and back in, then restart the script"
        exit 1
    }
    
    pull_kali_image || exit 1
    create_kali_with_nmap || print_info "Continuing despite potential issues..."
    
    print_header "Installation Complete!"
    show_docker_info
    
    read -p "Start Kali Linux container now? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Starting Kali Linux container..."
        sudo docker run -it kalilinux/kali-rolling /bin/bash
    else
        print_info "You can start the container anytime with:"
        echo -e "  ${BLUE}sudo docker run -it kalilinux/kali-rolling /bin/bash${NC}"
    fi
}

# Run main function
main
