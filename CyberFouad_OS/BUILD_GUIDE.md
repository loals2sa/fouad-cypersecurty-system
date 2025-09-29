# CyberFouad OS - Complete Build Guide

## 📋 Prerequisites

### System Requirements for Building
- **OS:** Debian 11/12 or Ubuntu 20.04/22.04 (or Kali Linux)
- **RAM:** 8 GB minimum, 16 GB recommended
- **Storage:** 50 GB free space
- **CPU:** 64-bit processor with 4+ cores
- **Internet:** Broadband connection for downloading packages

### Required Permissions
- Root/sudo access

## 🚀 Quick Build (Automated)

### Step 1: Generate Branding Assets

```bash
cd CyberFouad_OS/branding
pip3 install Pillow
python3 generate_hacker_branding.py
```

This creates:
- **3 Logo variants** (Matrix, Cyber Blue, Red Alert themes)
- **20 Unique wallpapers** (10x 4K, 10x 1080p)
- **Boot splash screen**
- All in `output/` directory

### Step 2: Build the ISO

```bash
cd ../iso_builder
chmod +x build_iso.sh
sudo ./build_iso.sh
```

**Build time:** 30-60 minutes depending on your system and internet speed.

The ISO will be created in `iso_builder/output/cyberfouad-os-2025.1-amd64.iso`

## 📦 What Gets Built

### Base System
- Debian 12 (Bookworm) base
- Linux kernel 6.1+
- XFCE4 desktop environment (lightweight and fast)
- NetworkManager for network management

### Pre-installed Tools (300+)

#### Network Analysis
- Wireshark, tcpdump, nmap, masscan
- Aircrack-ng suite, reaver, wifite
- Ettercap, bettercap, mitmproxy
- netcat, socat, arp-scan

#### Web Application Security
- SQLMap, Nikto, WPScan
- Burp Suite Community, OWASP ZAP
- Dirb, Gobuster, Dirbuster
- Whatweb, Wapiti

#### Password Cracking
- John the Ripper
- Hashcat
- Hydra, Medusa
- Crunch, Cewl

#### Exploitation
- Metasploit Framework
- ExploitDB local copy
- SearchSploit
- Social Engineering Toolkit

#### Forensics
- Autopsy, Sleuth Kit
- Volatility3
- Binwalk, Foremost
- dc3dd, Scalpel

#### Reverse Engineering
- Ghidra
- Radare2
- GDB, objdump
- ltrace, strace

#### OSINT
- Maltego
- theHarvester
- Recon-ng
- SpiderFoot

#### Utilities
- Tor Browser
- ProxyChains
- OpenVPN
- Steghide
- ExifTool

## 🎨 Customization

### Changing Branding Colors

Edit `branding/generate_hacker_branding.py`:

```python
COLOR_SCHEMES = {
    'your_theme': {
        'bg': (R, G, B),
        'primary': (R, G, B),
        'secondary': (R, G, B),
        'accent': (R, G, B),
        'glow': (R, G, B)
    }
}
```

### Adding More Tools

Edit `iso_builder/build_iso.sh` in the `install_packages.sh` section:

```bash
echo "Installing your custom tools..."
apt-get install -y \
    tool1 \
    tool2 \
    tool3
```

### Changing Desktop Environment

Replace XFCE4 with GNOME, KDE, or others in the installation script:

```bash
# For GNOME
apt-get install -y gnome-core gdm3

# For KDE Plasma
apt-get install -y kde-plasma-desktop sddm
```

## 🔧 Manual Build Process

If you want more control, follow these steps:

### 1. Install Dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
    debootstrap \
    squashfs-tools \
    genisoimage \
    syslinux \
    isolinux \
    xorriso \
    live-build \
    grub-pc-bin \
    grub-efi-amd64-bin
```

### 2. Create Build Environment

```bash
mkdir -p ~/cyberfouad-build/{chroot,iso,output}
cd ~/cyberfouad-build
```

### 3. Bootstrap Base System

```bash
sudo debootstrap --arch=amd64 --variant=minbase \
    bookworm chroot http://deb.debian.org/debian/
```

### 4. Configure System

```bash
sudo mount --bind /dev chroot/dev
sudo mount --bind /dev/pts chroot/dev/pts
sudo mount --bind /proc chroot/proc
sudo mount --bind /sys chroot/sys

sudo chroot chroot
```

Inside chroot:
```bash
# Update sources
cat > /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

apt-get update
apt-get install -y linux-image-amd64 live-boot systemd-sysv

# Install your desired packages...
# (see the automated script for full list)

exit
```

### 5. Create Squashfs

```bash
sudo umount chroot/{dev/pts,dev,proc,sys}
sudo mksquashfs chroot iso/casper/filesystem.squashfs -comp xz
```

### 6. Create Bootable ISO

```bash
sudo grub-mkrescue -o output/cyberfouad.iso iso/
```

## 💿 Creating Bootable USB

### On Linux

```bash
# Find your USB device
lsblk

# Write ISO to USB (replace /dev/sdX with your device)
sudo dd if=cyberfouad-os-2025.1-amd64.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

### On Windows

Use **Rufus** or **Etcher**:
1. Download Rufus from https://rufus.ie
2. Select your USB drive
3. Select the ISO file
4. Click "Start"

### On macOS

```bash
# Find USB device
diskutil list

# Unmount (replace diskN with your device)
diskutil unmountDisk /dev/diskN

# Write ISO
sudo dd if=cyberfouad-os-2025.1-amd64.iso of=/dev/rdiskN bs=4m
```

## 🧪 Testing the ISO

### In VirtualBox

1. Create new VM
2. Type: Linux
3. Version: Debian 64-bit
4. RAM: 4 GB minimum
5. Storage: Attach ISO to optical drive
6. Start VM

### In QEMU

```bash
qemu-system-x86_64 \
    -cdrom cyberfouad-os-2025.1-amd64.iso \
    -m 4096 \
    -enable-kvm \
    -boot d
```

### In VMware

1. Create New Virtual Machine
2. Select "Installer disc image file (iso)"
3. Guest OS: Linux > Debian 11.x 64-bit
4. Configure resources
5. Power on

## 🐛 Troubleshooting

### Build Fails: "No space left on device"
- Need at least 50 GB free space
- Clean up: `sudo apt-get clean && sudo apt-get autoremove`

### Build Fails: "Unable to fetch packages"
- Check internet connection
- Try different Debian mirror
- Update package lists: `sudo apt-get update`

### ISO Won't Boot
- Verify ISO integrity: `md5sum cyberfouad-os-2025.1-amd64.iso`
- Try different USB creation tool
- Check BIOS/UEFI boot settings

### Black Screen on Boot
- Try "Safe Graphics" mode from boot menu
- Add `nomodeset` to kernel parameters
- Update graphics drivers

### Packages Not Installing
- Check available disk space in chroot
- Verify package names: `apt-cache search <package>`
- Check Debian version compatibility

## 📊 Build Statistics

**Typical build produces:**
- ISO Size: 3-5 GB
- Installed Size: 8-12 GB
- Package Count: 2000+
- Tool Count: 300+
- Build Time: 30-60 minutes
- Download Size: 2-3 GB

## 🔒 Security Notes

### Default Credentials
**Live System:**
- Username: `cyberfouad`
- Password: `cyberfouad`

**Root:**
- Password: `toor`

### CHANGE THESE IMMEDIATELY IN PRODUCTION!

Edit in `build_iso.sh`:
```bash
echo "cyberfouad:YOUR_PASSWORD" | chpasswd
echo "root:YOUR_ROOT_PASSWORD" | chpasswd
```

## 📝 Adding Persistence

To save changes between reboots on USB:

1. Create persistence partition:
```bash
# After writing ISO to USB
sudo fdisk /dev/sdX
# Create new partition with remaining space
# Format as ext4
sudo mkfs.ext4 -L persistence /dev/sdX3

# Create persistence.conf
sudo mkdir /mnt/persistence
sudo mount /dev/sdX3 /mnt/persistence
echo "/ union" | sudo tee /mnt/persistence/persistence.conf
sudo umount /mnt/persistence
```

2. Boot with "Persistence" option from GRUB menu

## 🌐 Creating Network Install ISO

For smaller ISO that downloads packages during installation:

```bash
# Modify build script to use netinst
debootstrap --variant=minbase --include=live-boot \
    bookworm chroot http://deb.debian.org/debian/
```

## 📚 Additional Resources

- Debian Live Manual: https://live-team.pages.debian.net/live-manual/
- Live-build Documentation: https://wiki.debian.org/DebianLive
- GRUB Documentation: https://www.gnu.org/software/grub/manual/

## 🤝 Contributing

To add your own tools or modifications:

1. Fork the build scripts
2. Add packages to installation section
3. Test thoroughly in VM
4. Document changes
5. Share your custom ISO!

---

**CyberFouad OS** - Built for Security Professionals
