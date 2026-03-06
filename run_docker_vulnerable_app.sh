#!/bin/bash

# Docker Quick Start Script for Vulnerable Application

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  VULNERABLE APP - DOCKER QUICK START${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    echo -e "${YELLOW}Install with: sudo apt-get install -y docker.io${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker found${NC}"

# Ask user what they want to do
echo -e "\n${YELLOW}What would you like to do?${NC}"
echo "1) Build Docker image"
echo "2) Run vulnerable application in Docker"
echo "3) Run Parrot OS container with nmap"
echo "4) Exit"
read -p "Choose [1-4]: " choice

case $choice in
    1)
        echo -e "\n${GREEN}Building Docker image...${NC}"
        if [ -f "Dockerfile" ]; then
            docker build -t vuln-app:latest .
            echo -e "${GREEN}✓ Docker image built successfully${NC}"
            echo -e "${YELLOW}Run with: docker run -p 8080:8080 -p 2222:2222 -p 2121:2121 -p 2323:2323 -p 2525:2525 vuln-app:latest${NC}"
        else
            echo -e "${RED}✗ Dockerfile not found${NC}"
        fi
        ;;
    
    2)
        echo -e "\n${GREEN}Running vulnerable application in Docker...${NC}"
        docker run -it -p 8080:8080 -p 2222:2222 -p 2121:2121 -p 2323:2323 -p 2525:2525 \
            --name vuln-app-container vuln-app:latest
        ;;
    
    3)
        echo -e "\n${GREEN}Running Parrot OS container with nmap...${NC}"
        echo -e "${YELLOW}This container will be able to scan localhost:8080 and other services${NC}"
        docker run -it --network host parrotsec/security bash
        ;;
    
    4)
        echo -e "${YELLOW}Exiting...${NC}"
        exit 0
        ;;
    
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
