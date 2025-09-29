#!/bin/bash

################################################################################
# CyberFouad OS - ISO Builder Script
# Creates a complete bootable ISO with all cybersecurity tools
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DISTRO_NAME="CyberFouad OS"
DISTRO_VERSION="2025.1"
DISTRO_CODENAME="Shadow Strike"
ISO_NAME="cyberfouad-os-2025.1-amd64.iso"
BUILD_DIR="$(pwd)/build"
OUTPUT_DIR="$(pwd)/output"
WORK_DIR="$BUILD_DIR/work"
CHROOT_DIR="$BUILD_DIR/chroot"

echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "           CyberFouad OS - ISO Builder v1.0"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root (sudo)${NC}" 
   exit 1
fi

echo -e "${GREEN}[*] Checking system requirements...${NC}"

# Check required tools
REQUIRED_TOOLS="debootstrap squashfs-tools genisoimage syslinux isolinux xorriso"
MISSING_TOOLS=""

for tool in $REQUIRED_TOOLS; do
    if ! command -v $tool &> /dev/null; then
        MISSING_TOOLS="$MISSING_TOOLS $tool"
    fi
done

if [ -n "$MISSING_TOOLS" ]; then
    echo -e "${YELLOW}[!] Installing missing tools:$MISSING_TOOLS${NC}"
    apt-get update
    apt-get install -y debootstrap squashfs-tools genisoimage syslinux isolinux xorriso live-build
fi

echo -e "${GREEN}[✓] All requirements met${NC}\n"

# Create directory structure
echo -e "${GREEN}[*] Creating build directories...${NC}"
mkdir -p "$BUILD_DIR" "$OUTPUT_DIR" "$WORK_DIR" "$CHROOT_DIR"
mkdir -p "$WORK_DIR"/{iso,squashfs}
mkdir -p "$WORK_DIR/iso"/{casper,isolinux,install}

# Bootstrap base system
echo -e "${GREEN}[*] Bootstrapping Debian base system (this will take a while)...${NC}"
if [ ! -d "$CHROOT_DIR/usr" ]; then
    debootstrap --arch=amd64 --variant=minbase bookworm "$CHROOT_DIR" http://deb.debian.org/debian/
else
    echo -e "${YELLOW}[!] Base system already exists, skipping bootstrap${NC}"
fi

# Mount necessary filesystems
echo -e "${GREEN}[*] Mounting filesystems...${NC}"
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
mount --bind /proc "$CHROOT_DIR/proc"
mount --bind /sys "$CHROOT_DIR/sys"

# Configure chroot environment
echo -e "${GREEN}[*] Configuring chroot environment...${NC}"

cat > "$CHROOT_DIR/etc/apt/sources.list" << EOF
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

# Create installation script
cat > "$CHROOT_DIR/install_packages.sh" << 'INSTALL_SCRIPT'
#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export HOME=/root
export LC_ALL=C

echo "Updating package lists..."
apt-get update

echo "Installing base system..."
apt-get install -y \
    linux-image-amd64 \
    live-boot \
    systemd-sysv \
    network-manager \
    wireless-tools \
    wpasupplicant \
    curl \
    wget \
    vim \
    nano \
    git \
    build-essential

echo "Installing desktop environment (XFCE - lightweight)..."
apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    lightdm \
    lightdm-gtk-greeter \
    firefox-esr \
    thunar \
    mousepad

echo "Installing networking tools..."
apt-get install -y \
    nmap \
    netcat-openbsd \
    tcpdump \
    wireshark \
    tshark \
    aircrack-ng \
    reaver \
    ettercap-common \
    ettercap-graphical \
    dsniff \
    macchanger \
    arp-scan \
    netdiscover

echo "Installing web application testing tools..."
apt-get install -y \
    sqlmap \
    nikto \
    wpscan \
    dirb \
    gobuster \
    whatweb \
    w3af

echo "Installing password cracking tools..."
apt-get install -y \
    john \
    hashcat \
    hydra \
    medusa \
    crunch \
    ophcrack

echo "Installing exploitation frameworks..."
apt-get install -y \
    metasploit-framework \
    exploitdb

echo "Installing forensics tools..."
apt-get install -y \
    autopsy \
    sleuthkit \
    binwalk \
    foremost \
    volatility3 \
    scalpel \
    dc3dd

echo "Installing reverse engineering tools..."
apt-get install -y \
    radare2 \
    ghidra \
    gdb \
    ltrace \
    strace \
    hexedit \
    objdump

echo "Installing OSINT tools..."
apt-get install -y \
    maltego \
    theharvester \
    recon-ng \
    spiderfoot

echo "Installing additional utilities..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    openjdk-17-jdk \
    tor \
    proxychains4 \
    openvpn \
    steghide \
    exiftool

echo "Installing terminal tools..."
apt-get install -y \
    tmux \
    screen \
    htop \
    neofetch \
    tree \
    bat \
    fzf

echo "Cleaning up..."
apt-get autoremove -y
apt-get clean

# Configure system
echo "Configuring system..."

# Set hostname
echo "cyberfouad" > /etc/hostname

# Configure hosts
cat > /etc/hosts << EOF
127.0.0.1   localhost
127.0.1.1   cyberfouad
EOF

# Create default user
useradd -m -s /bin/bash -G sudo,netdev cyberfouad
echo "cyberfouad:cyberfouad" | chpasswd

# Set root password
echo "root:toor" | chpasswd

# Configure auto-login
mkdir -p /etc/lightdm/lightdm.conf.d/
cat > /etc/lightdm/lightdm.conf.d/50-autologin.conf << EOF
[Seat:*]
autologin-user=cyberfouad
autologin-user-timeout=0
EOF

# Enable services
systemctl enable NetworkManager
systemctl enable lightdm

echo "Installation complete!"
INSTALL_SCRIPT

chmod +x "$CHROOT_DIR/install_packages.sh"

# Run installation in chroot
echo -e "${GREEN}[*] Installing packages in chroot (this will take 15-30 minutes)...${NC}"
chroot "$CHROOT_DIR" /bin/bash -c "/install_packages.sh"

# Copy branding assets
echo -e "${GREEN}[*] Installing branding...${NC}"
if [ -d "../branding/output" ]; then
    mkdir -p "$CHROOT_DIR/usr/share/backgrounds/cyberfouad"
    mkdir -p "$CHROOT_DIR/usr/share/pixmaps/cyberfouad"
    
    cp ../branding/output/wallpapers/*.png "$CHROOT_DIR/usr/share/backgrounds/cyberfouad/" 2>/dev/null || true
    cp ../branding/output/logos/*.png "$CHROOT_DIR/usr/share/pixmaps/cyberfouad/" 2>/dev/null || true
fi

# Configure XFCE with wallpaper
chroot "$CHROOT_DIR" /bin/bash -c "
    mkdir -p /home/cyberfouad/.config/xfce4/xfconf/xfce-perchannel-xml/
    cat > /home/cyberfouad/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << 'XFCE_EOF'
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<channel name=\"xfce4-desktop\" version=\"1.0\">
  <property name=\"backdrop\" type=\"empty\">
    <property name=\"screen0\" type=\"empty\">
      <property name=\"monitor0\" type=\"empty\">
        <property name=\"workspace0\" type=\"empty\">
          <property name=\"image-path\" type=\"string\" value=\"/usr/share/backgrounds/cyberfouad/cyberfouad_wallpaper_01_matrix_matrix_1080p.png\"/>
          <property name=\"image-style\" type=\"int\" value=\"5\"/>
        </property>
      </property>
    </property>
  </property>
</channel>
XFCE_EOF
    chown -R cyberfouad:cyberfouad /home/cyberfouad/.config
"

# Clean up chroot
echo -e "${GREEN}[*] Cleaning up chroot...${NC}"
rm -f "$CHROOT_DIR/install_packages.sh"
chroot "$CHROOT_DIR" apt-get clean

# Unmount filesystems
echo -e "${GREEN}[*] Unmounting filesystems...${NC}"
umount "$CHROOT_DIR/dev/pts" || true
umount "$CHROOT_DIR/dev" || true
umount "$CHROOT_DIR/proc" || true
umount "$CHROOT_DIR/sys" || true

# Create squashfs filesystem
echo -e "${GREEN}[*] Creating squashfs filesystem (this may take a while)...${NC}"
mksquashfs "$CHROOT_DIR" "$WORK_DIR/iso/casper/filesystem.squashfs" -comp xz -b 1M

# Create filesystem.size
echo -e "${GREEN}[*] Creating filesystem.size...${NC}"
du -sx --block-size=1 "$CHROOT_DIR" | cut -f1 > "$WORK_DIR/iso/casper/filesystem.size"

# Copy kernel and initrd
echo -e "${GREEN}[*] Copying kernel and initrd...${NC}"
cp "$CHROOT_DIR/boot/vmlinuz-"* "$WORK_DIR/iso/casper/vmlinuz"
cp "$CHROOT_DIR/boot/initrd.img-"* "$WORK_DIR/iso/casper/initrd"

# Create GRUB configuration
echo -e "${GREEN}[*] Creating bootloader configuration...${NC}"
mkdir -p "$WORK_DIR/iso/boot/grub"

cat > "$WORK_DIR/iso/boot/grub/grub.cfg" << EOF
set default="0"
set timeout=10

menuentry "CyberFouad OS - Live System" {
    linux /casper/vmlinuz boot=casper quiet splash ---
    initrd /casper/initrd
}

menuentry "CyberFouad OS - Live System (Safe Graphics)" {
    linux /casper/vmlinuz boot=casper nomodeset quiet splash ---
    initrd /casper/initrd
}

menuentry "CyberFouad OS - Live System (Persistence)" {
    linux /casper/vmlinuz boot=casper persistent quiet splash ---
    initrd /casper/initrd
}
EOF

# Create disk info
cat > "$WORK_DIR/iso/.disk/info" << EOF
$DISTRO_NAME $DISTRO_VERSION "$DISTRO_CODENAME" - $(date +%Y%m%d)
EOF

# Create ISO
echo -e "${GREEN}[*] Creating ISO image...${NC}"
cd "$WORK_DIR/iso"

grub-mkrescue -o "$OUTPUT_DIR/$ISO_NAME" . \
    --modules="part_gpt part_msdos iso9660 normal boot linux" \
    --locales="" \
    --fonts="" \
    2>/dev/null

cd - > /dev/null

# Calculate MD5 checksum
echo -e "${GREEN}[*] Calculating checksums...${NC}"
cd "$OUTPUT_DIR"
md5sum "$ISO_NAME" > "$ISO_NAME.md5"
sha256sum "$ISO_NAME" > "$ISO_NAME.sha256"
cd - > /dev/null

ISO_SIZE=$(du -h "$OUTPUT_DIR/$ISO_NAME" | cut -f1)

echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "              BUILD COMPLETE!"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}"
echo "ISO Location: $OUTPUT_DIR/$ISO_NAME"
echo "ISO Size: $ISO_SIZE"
echo ""
echo "MD5:    $(cat "$OUTPUT_DIR/$ISO_NAME.md5" | cut -d' ' -f1)"
echo "SHA256: $(cat "$OUTPUT_DIR/$ISO_NAME.sha256" | cut -d' ' -f1)"
echo ""
echo "Default Credentials:"
echo "  Username: cyberfouad"
echo "  Password: cyberfouad"
echo ""
echo "  Root Password: toor"
echo -e "${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}To create bootable USB:${NC}"
echo "  sudo dd if=$OUTPUT_DIR/$ISO_NAME of=/dev/sdX bs=4M status=progress"
echo "  (Replace /dev/sdX with your USB device)"
echo ""
echo -e "${YELLOW}To test in Virtual Machine:${NC}"
echo "  Use VirtualBox, VMware, or QEMU with the ISO file"
echo ""
echo "═══════════════════════════════════════════════════════════════"
