#!/bin/bash

# Universal Vulnerable Application Launcher
# Works on both Kali Linux and Parrot OS (Docker)
# Auto-detects environment and runs accordingly

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Header
show_header() {
    clear
    echo -e "${BLUE}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║  VULNERABLE APPLICATION - UNIVERSAL LAUNCHER              ║${NC}"
    echo -e "${BLUE}${BOLD}║  Network Reconnaissance Training (Nmap PoC)               ║${NC}"
    echo -e "${BLUE}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

# Detect environment
detect_environment() {
    if [ -f "/.dockerenv" ]; then
        echo "DOCKER"
    elif grep -q "kali" /etc/hostname 2>/dev/null || grep -q "kali" /proc/version 2>/dev/null; then
        echo "KALI"
    elif grep -q "parrot" /etc/hostname 2>/dev/null; then
        echo "PARROT"
    else
        echo "OTHER"
    fi
}

# Utility functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_section() {
    echo -e "\n${CYAN}${BOLD}▶ $1${NC}"
}

# Check Python installation
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 not found"
        print_info "Installing Python3..."
        apt-get update >/dev/null 2>&1
        apt-get install -y python3 >/dev/null 2>&1
        print_success "Python3 installed"
    else
        print_success "Python3 found: $(python3 --version)"
    fi
}

# Check vulnerable app file
check_vuln_app() {
    if [ ! -f "vulnerable-app.py" ]; then
        print_error "vulnerable-app.py not found in current directory"
        print_info "Current directory: $(pwd)"
        print_info "Files available: $(ls *.py 2>/dev/null | head -3)"
        return 1
    fi
    print_success "vulnerable-app.py found"
    return 0
}

# Kali Linux execution
run_kali() {
    print_section "KALI LINUX - NATIVE EXECUTION"
    echo ""
    
    check_python
    check_vuln_app || exit 1
    
    echo -e "\n${YELLOW}Configuration:${NC}"
    echo "  • Environment: Kali Linux (VirtualBox)"
    echo "  • Python: Native"
    echo "  • Services: 5 ports (8080, 2222, 2121, 2323, 2525)"
    echo ""
    
    print_info "Starting Vulnerable Application..."
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
    
    python3 vulnerable-app.py
}

# Docker execution
run_docker() {
    print_section "DOCKER - CONTAINERIZED EXECUTION"
    echo ""
    
    check_python
    check_vuln_app || exit 1
    
    echo -e "\n${YELLOW}Configuration:${NC}"
    echo "  • Environment: Docker Container"
    echo "  • Image: parrotsec/security or available"
    echo "  • Services: 5 ports (8080, 2222, 2121, 2323, 2525)"
    echo ""
    
    print_info "Starting Vulnerable Application in Docker..."
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
    
    python3 vulnerable-app.py
}

# Other Linux execution
run_other() {
    print_section "GENERIC LINUX - EXECUTION"
    echo ""
    
    check_python
    check_vuln_app || exit 1
    
    echo -e "\n${YELLOW}Configuration:${NC}"
    echo "  • Environment: Generic Linux"
    echo "  • Python: Available"
    echo "  • Services: 5 ports (8080, 2222, 2121, 2323, 2525)"
    echo ""
    
    print_info "Starting Vulnerable Application..."
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
    
    python3 vulnerable-app.py
}

# Show usage instructions
show_instructions() {
    cat << 'EOF'

════════════════════════════════════════════════════════════════
  SCANNING INSTRUCTIONS
════════════════════════════════════════════════════════════════

1. KEEP THIS TERMINAL RUNNING

2. OPEN A NEW TERMINAL and run:

   ┌─ QUICK SCAN ─────────────────────────────────────────────┐
   │ nmap -sV localhost                                        │
   └───────────────────────────────────────────────────────────┘

   ┌─ AGGRESSIVE SCAN ─────────────────────────────────────────┐
   │ sudo nmap -A localhost                                    │
   └───────────────────────────────────────────────────────────┘

   ┌─ VULNERABILITY DETECTION ────────────────────────────────┐
   │ nmap --script vuln localhost                              │
   └───────────────────────────────────────────────────────────┘

   ┌─ SPECIFIC PORTS ──────────────────────────────────────────┐
   │ nmap -p 8080,2222,2121,2323,2525 -sV localhost           │
   └───────────────────────────────────────────────────────────┘

3. FOR DOCKER/PARROT:
   
   ┌─ FROM HOST ───────────────────────────────────────────────┐
   │ sudo docker run --network host parrotsec/security nmap \  │
   │   -sV 127.0.0.1                                           │
   └───────────────────────────────────────────────────────────┘

   ┌─ FROM CONTAINER ──────────────────────────────────────────┐
   │ sudo docker exec <container_id> nmap -sV 127.0.0.1       │
   └───────────────────────────────────────────────────────────┘

════════════════════════════════════════════════════════════════

EXPECTED FINDINGS:
  ✓ Port 8080 - HTTP with vulnerabilities
  ✓ Port 2222 - SSH (very old version)
  ✓ Port 2121 - FTP (anonymous login)
  ✓ Port 2323 - Telnet (unencrypted)
  ✓ Port 2525 - SMTP (old Sendmail)

════════════════════════════════════════════════════════════════

EOF
}

# Main flow
main() {
    show_header
    
    ENVIRONMENT=$(detect_environment)
    
    print_info "Detecting environment..."
    echo -e "  → Environment: ${YELLOW}${BOLD}${ENVIRONMENT}${NC}\n"
    
    case $ENVIRONMENT in
        KALI)
            run_kali
            ;;
        DOCKER)
            run_docker
            ;;
        PARROT)
            run_docker
            ;;
        OTHER)
            run_other
            ;;
    esac
}

# Trap Ctrl+C
trap ctrl_c INT

ctrl_c() {
    echo -e "\n\n${RED}${BOLD}Shutting down...${NC}"
    echo -e "${GREEN}✓ Application stopped${NC}"
    exit 0
}

# Show instructions before starting
show_header
show_instructions

# Wait for user acknowledgement
echo -e "\n${YELLOW}${BOLD}Press ENTER to start the vulnerable application...${NC}"
read -r

# Run main
main
