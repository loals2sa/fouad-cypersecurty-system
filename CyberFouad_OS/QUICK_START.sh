#!/bin/bash

################################################################################
# CyberFouad OS - Quick Start Script
# One-command setup to build complete ISO
################################################################################

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear

echo -e "${CYAN}"
cat << "EOF"
 ██████╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗ ██████╗ ██╗   ██╗ █████╗ ██████╗ 
██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔══██╗
██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██║   ██║███████║██║  ██║
██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██║   ██║██╔══██║██║  ██║
╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║     ╚██████╔╝╚██████╔╝██║  ██║██████╔╝
 ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
                                                                                     
                     UNLEASH YOUR CYBER POWER
                          Quick Start v1.0
EOF
echo -e "${NC}\n"

echo -e "${YELLOW}This script will:${NC}"
echo "  1. Install required dependencies"
echo "  2. Generate all branding assets (logos, wallpapers)"
echo "  3. Build the complete CyberFouad OS ISO"
echo ""
echo -e "${YELLOW}Requirements:${NC}"
echo "  - Debian/Ubuntu/Kali Linux"
echo "  - 50GB free disk space"
echo "  - 8GB RAM minimum"
echo "  - Sudo/root access"
echo "  - Internet connection"
echo ""
echo -e "${YELLOW}Build time: 30-60 minutes${NC}"
echo ""

read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Check if running on compatible system
if [ ! -f /etc/debian_version ]; then
    echo -e "${RED}Error: This script requires Debian, Ubuntu, or Kali Linux${NC}"
    exit 1
fi

# Check disk space
AVAILABLE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE" -lt 30 ]; then
    echo -e "${RED}Error: Insufficient disk space. Need 30GB minimum, have ${AVAILABLE}GB${NC}"
    echo -e "${YELLOW}Note: Full build recommended 50GB, but optimized build works with 30GB${NC}"
    exit 1
fi

if [ "$AVAILABLE" -lt 50 ]; then
    echo -e "${YELLOW}⚠️  Warning: You have ${AVAILABLE}GB available.${NC}"
    echo -e "${YELLOW}   Recommended: 50GB for full build${NC}"
    echo -e "${YELLOW}   You have enough for optimized build (30GB minimum)${NC}"
    echo ""
    read -p "Continue with optimized build? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted. Free up more space and try again."
        exit 1
    fi
    OPTIMIZED_BUILD=true
else
    OPTIMIZED_BUILD=false
fi

echo ""
echo -e "${GREEN}[1/3] Installing dependencies...${NC}"
echo ""

# Install Python and Pillow for branding
if ! command -v python3 &> /dev/null; then
    echo "Installing Python3..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
fi

if ! python3 -c "import PIL" 2>/dev/null; then
    echo "Installing Pillow..."
    pip3 install Pillow || sudo apt-get install -y python3-pil
fi

# Install ISO build tools
echo "Installing ISO build tools..."
sudo apt-get install -y \
    debootstrap \
    squashfs-tools \
    genisoimage \
    syslinux \
    isolinux \
    xorriso \
    live-build \
    grub-pc-bin \
    grub-efi-amd64-bin 2>&1 | grep -v "^Selecting\|^Preparing\|^Unpacking"

echo ""
echo -e "${GREEN}[2/3] Generating branding assets...${NC}"
echo ""

cd branding
python3 generate_hacker_branding.py

cd ..

echo ""
echo -e "${GREEN}[3/3] Building ISO...${NC}"
echo -e "${YELLOW}This will take 30-60 minutes. Get some coffee! ☕${NC}"
echo ""

cd iso_builder
chmod +x build_iso.sh

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "Running ISO build with sudo..."
    sudo ./build_iso.sh
else
    ./build_iso.sh
fi

cd ..

echo ""
echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "                    SETUP COMPLETE!"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}"
echo "✓ Branding assets generated"
echo "✓ ISO built successfully"
echo ""
echo "ISO Location:"
echo "  $(pwd)/iso_builder/output/cyberfouad-os-2025.1-amd64.iso"
echo ""
echo "Next Steps:"
echo ""
echo "1. TEST IN VIRTUAL MACHINE:"
echo "   VirtualBox: Load the ISO as optical drive"
echo "   QEMU: qemu-system-x86_64 -cdrom <iso> -m 4096"
echo ""
echo "2. CREATE BOOTABLE USB:"
echo "   sudo dd if=<iso> of=/dev/sdX bs=4M status=progress"
echo "   (Replace /dev/sdX with your USB device)"
echo ""
echo "3. BOOT & ENJOY!"
echo "   Default credentials:"
echo "   Username: cyberfouad"
echo "   Password: cyberfouad"
echo ""
echo "Documentation:"
echo "  - README.md - Overview"
echo "  - BUILD_GUIDE.md - Detailed build instructions"
echo "  - TOOLS_LIST.md - All 300+ included tools"
echo -e "${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${CYAN}CyberFouad OS - Unleash Your Cyber Power!${NC}"
echo ""
