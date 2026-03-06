#!/bin/bash
# install_parrot_docker.sh - Install Parrot Linux in Docker with Nmap

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

pull_parrot_image() {
    print_header "Pulling Parrot Linux Image"
    
    print_info "Downloading Parrot Security image (~1GB)..."
    if sudo docker pull parrotsec/security; then
        print_success "Parrot Linux image pulled successfully"
    else
        print_error "Failed to pull Parrot Linux image"
        print_info "Trying alternative image name..."
        if sudo docker pull parrot:latest; then
            print_success "Parrot Linux image pulled successfully"
        else
            print_error "Could not download Parrot image"
            return 1
        fi
    fi
}

create_parrot_with_nmap() {
    print_header "Creating Parrot Container with Nmap"
    
    print_info "Creating container with Nmap pre-installed..."
    
    # Determine which image is available
    IMAGE_NAME="parrotsec/security"
    if ! sudo docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
        IMAGE_NAME="parrot:latest"
    fi
    
    CONTAINER_NAME="parrot-linux-nmap-$(date +%s)"
    
    print_info "Installing Nmap in container..."
    sudo docker run --rm "$IMAGE_NAME" bash -c \
        "apt-get update && apt-get install -y nmap" > /dev/null 2>&1 && \
        print_success "Nmap installation completed" || \
        print_error "Warning: Nmap installation had issues"
    
    print_success "Container created successfully"
}

show_docker_info() {
    print_header "Docker Usage Information"
    
    # Determine which image is available
    IMAGE_NAME="parrotsec/security"
    if ! sudo docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
        IMAGE_NAME="parrot:latest"
    fi
    
    echo -e "${GREEN}To start Parrot with Nmap:${NC}"
    echo -e "  ${BLUE}sudo docker run -it $IMAGE_NAME bash${NC}"
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
    echo ""
    echo -e "${YELLOW}Note: This script uses parrotsec/security or parrot:latest images${NC}"
}

# Main execution
main() {
    print_header "Parrot Linux Docker Installation"
    
    check_docker || {
        print_error "Please run 'newgrp docker' or log out and back in, then restart the script"
        exit 1
    }
    
    pull_parrot_image || exit 1
    create_parrot_with_nmap || print_info "Continuing despite potential issues..."
    
    print_header "Installation Complete!"
    show_docker_info
    
    read -p "Start Parrot Linux container now? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Starting Parrot Linux container..."
        # Determine which image is available
        IMAGE_NAME="parrotsec/security"
        if ! sudo docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
            IMAGE_NAME="parrot:latest"
        fi
        sudo docker run -it "$IMAGE_NAME" /bin/bash
    else
        print_info "You can start the container anytime with:"
        IMAGE_NAME="parrotsec/security"
        if ! sudo docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
            IMAGE_NAME="parrot:latest"
        fi
        echo -e "  ${BLUE}sudo docker run -it $IMAGE_NAME /bin/bash${NC}"
    fi
}

# Run main function
main
