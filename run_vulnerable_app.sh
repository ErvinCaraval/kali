#!/bin/bash

# Run Vulnerable Application - Easy Setup Script

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  VULNERABLE APP - QUICK START${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check if Python3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python3 is not installed${NC}"
    echo -e "${YELLOW}Install with: sudo apt-get install -y python3${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Python3 found${NC}"

# Check if vulnerable-app.py exists
if [ ! -f "vulnerable-app.py" ]; then
    echo -e "${RED}✗ vulnerable-app.py not found in current directory${NC}"
    echo -e "${YELLOW}Please run this script from the directory containing vulnerable-app.py${NC}"
    exit 1
fi

echo -e "${GREEN}✓ vulnerable-app.py found${NC}"

# Display instructions
echo -e "\n${YELLOW}Instructions:${NC}"
echo -e "1. This terminal will run the vulnerable application"
echo -e "2. Open a NEW terminal"
echo -e "3. Run nmap scans from the new terminal"
echo -e "4. Examples:\n"
echo -e "   ${BLUE}nmap -sV -p 8080,2222,2121,2323,2525 localhost${NC}"
echo -e "   ${BLUE}nmap -A localhost${NC}"
echo -e "   ${BLUE}nmap --script vuln localhost${NC}"
echo -e "\n5. Press Ctrl+C in this terminal to stop\n"

# Run the application
echo -e "${GREEN}Starting vulnerable application...${NC}\n"
python3 vulnerable-app.py
