#!/bin/bash

################################################################################
# CyberFouad OS - Quick Space Cleaner
# Frees up disk space quickly and safely
################################################################################

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "           CyberFouad OS - Quick Space Cleaner"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}\n"

# Check current space
BEFORE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
echo -e "${YELLOW}Current available space: ${BEFORE}GB${NC}\n"

if [ "$BEFORE" -ge 50 ]; then
    echo -e "${GREEN}✓ You already have enough space (50GB+)${NC}"
    echo "You can run the full build without cleaning."
    exit 0
fi

echo "This script will safely clean:"
echo "  1. Package manager cache (apt)"
echo "  2. Old/unused packages"
echo "  3. Thumbnail cache"
echo "  4. Temporary files"
echo "  5. Old log files"
echo ""
echo -e "${YELLOW}This is safe and won't delete your personal files.${NC}"
echo ""

read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo -e "${GREEN}[1/6] Cleaning package manager cache...${NC}"
sudo apt-get clean
sudo apt-get autoclean

echo -e "${GREEN}[2/6] Removing unused packages...${NC}"
sudo apt-get autoremove -y

echo -e "${GREEN}[3/6] Cleaning thumbnail cache...${NC}"
rm -rf ~/.cache/thumbnails/* 2>/dev/null || true

echo -e "${GREEN}[4/6] Cleaning temporary files...${NC}"
sudo rm -rf /tmp/* 2>/dev/null || true
sudo rm -rf /var/tmp/* 2>/dev/null || true

echo -e "${GREEN}[5/6] Cleaning old logs...${NC}"
if command -v journalctl &> /dev/null; then
    sudo journalctl --vacuum-time=3d
fi

echo -e "${GREEN}[6/6] Cleaning user cache...${NC}"
rm -rf ~/.cache/mozilla/firefox/*/cache2/* 2>/dev/null || true
rm -rf ~/.cache/chromium/Default/Cache/* 2>/dev/null || true

# Check space after
AFTER=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
FREED=$((AFTER - BEFORE))

echo ""
echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "                     CLEANING COMPLETE"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}"
echo "Space before: ${BEFORE}GB"
echo "Space after:  ${AFTER}GB"
echo "Space freed:  ${FREED}GB"
echo ""

if [ "$AFTER" -ge 50 ]; then
    echo "✓ SUCCESS! You now have enough space for full build (50GB+)"
    echo ""
    echo "Run the build now:"
    echo "  sudo ./QUICK_START.sh"
elif [ "$AFTER" -ge 30 ]; then
    echo "✓ You have enough for optimized build (30GB+)"
    echo ""
    echo "Run the optimized build:"
    echo "  sudo ./QUICK_START.sh"
else
    echo "⚠️  Still need more space. Current: ${AFTER}GB, Need: 30GB minimum"
    echo ""
    echo "Additional options:"
    echo "  1. Remove large files from ~/Downloads/"
    echo "  2. Remove old VM images or ISOs"
    echo "  3. Move to external drive"
    echo "  4. Run: sudo du -h / | sort -rh | head -20"
    echo "     (to find large directories)"
fi

echo -e "${NC}"
echo "═══════════════════════════════════════════════════════════════"
