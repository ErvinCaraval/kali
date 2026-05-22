#!/bin/bash

# install_kali_parrot_menu.sh
# Menu-driven script for installing Kali Linux and Parrot OS (Cross-platform: Linux, macOS, Windows/WSL)

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

echo "======================================="
echo "   Kali/Parrot Linux Setup Menu        "
echo "   Detected OS: $OS"
echo "======================================="
echo ""

if [ "$OS" = "Windows" ]; then
    echo "⚠  WARNING: Windows detected."
    echo "   For Windows, you need WSL2 (Windows Subsystem for Linux 2)."
    echo "   Please install WSL2 first: https://docs.microsoft.com/windows/wsl/install"
    echo ""
fi

echo "Please choose an installation method:"
echo "1) VirtualBox Image (Full Desktop/GUI)"
echo "2) Docker Container (Minimal/CLI Only)"
echo "3) Exit"
echo ""

read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Starting VirtualBox installation..."
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [ -f "$SCRIPT_DIR/install_kali_vbox.sh" ]; then
            bash "$SCRIPT_DIR/install_kali_vbox.sh"
        else
            echo "Error: install_kali_vbox.sh not found in the current directory."
            exit 1
        fi
        ;;
    2)
        echo "Starting Docker installation..."
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [ -f "$SCRIPT_DIR/install_parrot_docker.sh" ]; then
            bash "$SCRIPT_DIR/install_parrot_docker.sh"
        else
            echo "Error: install_parrot_docker.sh not found in the current directory."
            exit 1
        fi
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid selection. Exiting..."
        exit 1
        ;;
esac
