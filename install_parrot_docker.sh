#!/bin/bash
# install_parrot_docker.sh - Install Parrot Linux in Docker with Nmap (Linux, macOS, Windows/WSL2)

set -e  # Exit on error

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*) OS="Linux" ;;
        Darwin*) OS="macOS" ;;
        MINGW* | MSYS* | CYGWIN*) OS="Windows" ;;
        *) OS="Unknown" ;;
    esac
}

detect_os

# Colors for output (disable on Windows)
if [ "$OS" = "Windows" ]; then
    RED=''; GREEN=''; YELLOW=''; BLUE=''; NC=''
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

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
        case $OS in
            Linux)
                # Linux installation
                sudo apt-get update && sudo apt-get install -y docker.io
                sudo systemctl enable --now docker
                sudo usermod -aG docker $USER
                
                print_success "Docker installed successfully"
                print_info "You need to log out and log back in, or run:"
                print_info "  newgrp docker"
                return 1
                ;;
            macOS)
                # macOS installation
                print_info "Installing Docker Desktop for macOS..."
                print_info "Using Homebrew: brew install docker"
                brew install docker || {
                    print_error "Brew installation failed. Please install Docker Desktop manually:"
                    print_info "Download from: https://www.docker.com/products/docker-desktop"
                    return 1
                }
                print_success "Docker installed successfully"
                ;;
            Windows)
                print_error "Docker must be installed on Windows via Docker Desktop"
                print_info "Download from: https://www.docker.com/products/docker-desktop"
                print_info "Or install WSL2 first, then use: apt-get install docker.io"
                return 1
                ;;
        esac
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
    
    # Cross-platform timestamp generation
    if command -v date &> /dev/null && date +%s > /dev/null 2>&1; then
        TIMESTAMP=$(date +%s)
    else
        TIMESTAMP=$(printf "%(%s)T" -1)
    fi
    CONTAINER_NAME="parrot-linux-nmap-$TIMESTAMP"
    
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
    
    if [ "$OS" = "Windows" ]; then
        echo -e "${YELLOW}Note: Running from WSL2. For best performance, ensure Docker Desktop is configured to use WSL2 backend${NC}"
    else
        echo -e "${YELLOW}Note: This script uses $IMAGE_NAME image${NC}"
    fi
}

# Main execution
main() {
    print_header "Parrot Linux Docker Installation"
    echo -e "${YELLOW}Detected OS: $OS${NC}"
    
    if [ "$OS" = "Windows" ]; then
        echo -e "${YELLOW}Note: Windows detected. Ensure you're running WSL2 or Git Bash${NC}"
    fi
    
    check_docker || {
        print_error "Docker setup failed. Please check the instructions above and try again."
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
