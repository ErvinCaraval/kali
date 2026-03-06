#!/bin/bash

# install_kali_parrot_menu.sh
# Menu-driven script for installing Kali Linux and Parrot OS

echo "======================================="
echo "      Kali Linux Setup Menu            "
echo "======================================="
echo ""
echo "Please choose an installation method:"
echo "1) VirtualBox Image (Full Desktop/GUI)"
echo "2) Docker Container (Minimal/CLI Only)"
echo "3) Exit"
echo ""

read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Starting VirtualBox installation..."
        if [ -f "./install_kali_vbox.sh" ]; then
            ./install_kali_vbox.sh
        else
            echo "Error: install_kali_vbox.sh not found in the current directory."
        fi
        ;;
    2)
        echo "Starting Docker installation..."
        if [ -f "./install_parrot_docker.sh" ]; then
            ./install_parrot_docker.sh
        else
            echo "Error: install_parrot_docker.sh not found in the current directory."
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
