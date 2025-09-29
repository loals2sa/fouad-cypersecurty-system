# Fouad System - Branding Installation Guide

This guide explains how to integrate the Fouad System branding assets into your Linux distribution.

## 📋 Table of Contents

1. [Logo Installation](#logo-installation)
2. [Desktop Wallpaper Setup](#desktop-wallpaper-setup)
3. [Boot Splash (Plymouth)](#boot-splash-plymouth)
4. [GRUB Theme](#grub-theme)
5. [Installer Integration](#installer-integration)
6. [Desktop Environment Customization](#desktop-environment-customization)

---

## 🎨 Logo Installation

### System-Wide Logo Placement

```bash
# Create branding directory
sudo mkdir -p /usr/share/pixmaps/fouad-system

# Copy logos
sudo cp logos/fouad_system_logo_dark.png /usr/share/pixmaps/fouad-system/logo.png
sudo cp logos/fouad_system_logo_dark.svg /usr/share/pixmaps/fouad-system/logo.svg
sudo cp logos/fouad_system_logo_light.png /usr/share/pixmaps/fouad-system/logo-light.png

# Set permissions
sudo chmod 644 /usr/share/pixmaps/fouad-system/*
```

### Application Menu Icon

```bash
# Copy to standard icon location
sudo cp logos/fouad_system_logo_dark.png /usr/share/pixmaps/fouad-system-logo.png

# Update your distribution's menu configuration
# Edit /etc/xdg/menus/applications.menu or equivalent
```

---

## 🖼️ Desktop Wallpaper Setup

### GNOME

```bash
# Copy wallpapers
sudo mkdir -p /usr/share/backgrounds/fouad-system
sudo cp wallpapers/*.png /usr/share/backgrounds/fouad-system/

# Create XML metadata
sudo tee /usr/share/gnome-background-properties/fouad-system.xml > /dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>Fouad System</name>
    <filename>/usr/share/backgrounds/fouad-system/fouad_system_wallpaper_4k.png</filename>
    <options>zoom</options>
  </wallpaper>
</wallpapers>
EOF

# Set as default
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/fouad-system/fouad_system_wallpaper_4k.png
```

### KDE Plasma

```bash
# Copy wallpapers
sudo mkdir -p /usr/share/wallpapers/FouadSystem
sudo cp wallpapers/fouad_system_wallpaper_4k.png /usr/share/wallpapers/FouadSystem/contents/images/2160x3840.png
sudo cp wallpapers/fouad_system_wallpaper_1080p.png /usr/share/wallpapers/FouadSystem/contents/images/1080x1920.png

# Create metadata
sudo tee /usr/share/wallpapers/FouadSystem/metadata.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Fouad System

[Wallpaper]
Type=Image
EOF
```

### XFCE

```bash
# Copy wallpapers
sudo cp wallpapers/*.png /usr/share/backgrounds/

# Set via xfconf
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image \
  -s /usr/share/backgrounds/fouad_system_wallpaper_1080p.png
```

### Set as Default for New Users

```bash
# Create default user configuration
sudo mkdir -p /etc/skel/.config
# Copy your desktop environment's wallpaper configuration to /etc/skel/
```

---

## 🚀 Boot Splash (Plymouth)

### Install Plymouth Theme

```bash
# Create theme directory
sudo mkdir -p /usr/share/plymouth/themes/fouad-system

# Copy boot splash
sudo cp boot_splash/fouad_system_boot_splash.png /usr/share/plymouth/themes/fouad-system/background.png

# Create theme configuration
sudo tee /usr/share/plymouth/themes/fouad-system/fouad-system.plymouth > /dev/null <<EOF
[Plymouth Theme]
Name=Fouad System
Description=Fouad System boot splash
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/fouad-system
ScriptFile=/usr/share/plymouth/themes/fouad-system/fouad-system.script
EOF

# Create script file
sudo tee /usr/share/plymouth/themes/fouad-system/fouad-system.script > /dev/null <<'EOF'
# Fouad System Plymouth Theme Script

background_image = Image("background.png");
screen_width = Window.GetWidth();
screen_height = Window.GetHeight();
resized_background_image = background_image.Scale(screen_width, screen_height);
background_sprite = Sprite(resized_background_image);
background_sprite.SetZ(-100);

# Progress bar
progress_bar.original_image = Image("progress_bar.png");
progress_bar.sprite = Sprite();
progress_bar.x = Window.GetWidth() / 2 - progress_bar.original_image.GetWidth() / 2;
progress_bar.y = Window.GetHeight() * 0.75;
progress_bar.sprite.SetPosition(progress_bar.x, progress_bar.y, 2);

fun progress_callback(duration, progress) {
    if (progress_bar.original_image) {
        progress_bar.image = progress_bar.original_image.Scale(
            progress_bar.original_image.GetWidth() * progress, 
            progress_bar.original_image.GetHeight()
        );
        progress_bar.sprite.SetImage(progress_bar.image);
    }
}

Plymouth.SetBootProgressFunction(progress_callback);
EOF

# Set as default theme
sudo plymouth-set-default-theme -R fouad-system

# Update initramfs
sudo update-initramfs -u
```

---

## 🎯 GRUB Theme

### Create GRUB Background

```bash
# Copy boot splash as GRUB background
sudo cp boot_splash/fouad_system_boot_splash.png /boot/grub/fouad-system-grub.png

# Edit GRUB configuration
sudo nano /etc/default/grub

# Add or modify these lines:
# GRUB_BACKGROUND="/boot/grub/fouad-system-grub.png"
# GRUB_GFXMODE=1920x1080
# GRUB_GFXPAYLOAD_LINUX=keep

# Update GRUB
sudo update-grub
```

### Advanced GRUB Theme (Optional)

```bash
# Create custom GRUB theme directory
sudo mkdir -p /boot/grub/themes/fouad-system

# Copy background
sudo cp boot_splash/fouad_system_boot_splash.png /boot/grub/themes/fouad-system/background.png

# Create theme.txt
sudo tee /boot/grub/themes/fouad-system/theme.txt > /dev/null <<EOF
# Fouad System GRUB Theme

# Screen resolution
desktop-image: "background.png"
title-text: ""
title-font: "DejaVu Sans Bold 24"
title-color: "#00b4d8"

# Boot menu
+ boot_menu {
  left = 30%
  width = 40%
  top = 40%
  height = 35%
  
  item_color = "#ffffff"
  selected_item_color = "#00c8ff"
  item_height = 32
  item_padding = 10
  item_spacing = 5
  
  selected_item_pixmap_style = "select_*.png"
}

# Progress bar
+ progress_bar {
  id = "__timeout__"
  left = 30%
  width = 40%
  top = 80%
  height = 24
  
  fg_color = "#00b4d8"
  bg_color = "#1a1a2e"
  border_color = "#00c8ff"
}
EOF

# Enable theme in GRUB config
echo 'GRUB_THEME="/boot/grub/themes/fouad-system/theme.txt"' | sudo tee -a /etc/default/grub

# Update GRUB
sudo update-grub
```

---

## 💿 Installer Integration

### Calamares Installer

```bash
# Copy installer background
sudo mkdir -p /etc/calamares/branding/fouad-system
sudo cp installer/fouad_system_installer_bg.png /etc/calamares/branding/fouad-system/background.png
sudo cp logos/fouad_system_logo_dark.png /etc/calamares/branding/fouad-system/logo.png

# Create branding configuration
sudo tee /etc/calamares/branding/fouad-system/branding.desc > /dev/null <<EOF
---
componentName: fouad-system

strings:
    productName: "Fouad System"
    version: "2025"
    shortVersion: "2025"
    versionedName: "Fouad System 2025"
    shortVersionedName: "Fouad System 2025"
    bootloaderEntryName: "Fouad System"
    productUrl: "https://fouadsystem.com"
    supportUrl: "https://fouadsystem.com/support"

images:
    productLogo: "logo.png"
    productIcon: "logo.png"

style:
   sidebarBackground: "#0a0f19"
   sidebarText: "#ffffff"
   sidebarTextSelect: "#00b4d8"

slideshow: "show.qml"

uploadServer:
    type: "none"
EOF

# Update Calamares settings to use this branding
sudo sed -i 's/branding:.*/branding: fouad-system/' /etc/calamares/settings.conf
```

### Debian Installer (d-i)

```bash
# For Debian-based installers, copy logos to:
sudo cp logos/fouad_system_logo_dark.png /usr/share/graphics/logo_installer.png
sudo cp wallpapers/fouad_system_wallpaper_1080p.png /usr/share/graphics/background.png
```

---

## 🖥️ Desktop Environment Customization

### Login Manager (LightDM)

```bash
# Copy background
sudo cp wallpapers/fouad_system_wallpaper_1080p.png /usr/share/pixmaps/fouad-system-login-bg.png

# Edit LightDM configuration
sudo nano /etc/lightdm/lightdm-gtk-greeter.conf

# Add or modify:
# [greeter]
# background=/usr/share/pixmaps/fouad-system-login-bg.png
# theme-name=Adwaita-dark
# icon-theme-name=Adwaita
# logo=/usr/share/pixmaps/fouad-system/logo.png
```

### GDM (GNOME Display Manager)

```bash
# Extract and modify GDM theme
sudo mkdir -p /usr/share/gnome-shell/theme/fouad-system
sudo cp wallpapers/fouad_system_wallpaper_1080p.png /usr/share/gnome-shell/theme/fouad-system/background.png

# Update GDM CSS (requires glib-compile-resources)
# This is distribution-specific and may require additional steps
```

### SDDM (KDE Display Manager)

```bash
# Create SDDM theme
sudo mkdir -p /usr/share/sddm/themes/fouad-system
sudo cp wallpapers/fouad_system_wallpaper_1080p.png /usr/share/sddm/themes/fouad-system/background.png
sudo cp logos/fouad_system_logo_dark.png /usr/share/sddm/themes/fouad-system/logo.png

# Create theme.conf
sudo tee /usr/share/sddm/themes/fouad-system/theme.conf > /dev/null <<EOF
[General]
background=background.png
logo=logo.png
type=image
EOF

# Set as default
sudo nano /etc/sddm.conf
# [Theme]
# Current=fouad-system
```

---

## 🎨 Additional Customizations

### Terminal/Console Boot Logo

```bash
# For console boot messages (optional)
sudo cp logos/fouad_system_logo_dark.png /usr/share/pixmaps/fouad-system-console.png
```

### Distribution Release Information

```bash
# Update /etc/os-release
sudo tee -a /etc/os-release > /dev/null <<EOF
LOGO=fouad-system-logo
ANSI_COLOR="0;38;2;0;180;216"
EOF
```

### Icon Theme Integration

```bash
# Place logos in standard icon theme locations
sudo mkdir -p /usr/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256,512x512}/apps

# You can scale the main logo to these sizes or use specific variants
# Example for 256x256:
sudo cp logos/fouad_system_logo_dark.png /usr/share/icons/hicolor/256x256/apps/fouad-system.png

# Update icon cache
sudo gtk-update-icon-cache /usr/share/icons/hicolor/
```

---

## 📝 Testing Your Installation

After installation, verify each component:

```bash
# Check Plymouth theme
sudo plymouth-set-default-theme --list
sudo plymouth-set-default-theme --reset

# Check GRUB background
ls -l /boot/grub/*.png

# Check wallpapers
ls -l /usr/share/backgrounds/

# Test display manager
sudo systemctl restart lightdm  # or gdm, sddm
```

---

## 🔧 Troubleshooting

### Plymouth Not Showing

- Ensure `splash` is in GRUB kernel parameters
- Check `/etc/default/grub` for `GRUB_CMDLINE_LINUX_DEFAULT`
- Regenerate initramfs: `sudo update-initramfs -u`

### GRUB Background Not Displaying

- Verify image path in `/etc/default/grub`
- Ensure image is PNG format
- Run `sudo update-grub` after changes
- Check GRUB resolution settings

### Wallpaper Not Setting

- Verify file permissions (should be readable)
- Check desktop environment-specific configurations
- Ensure correct file paths

---

## 📚 Additional Resources

- Review `README.md` for design specifications
- Open `PREVIEW.html` in a browser to see all assets
- Modify colors in source files for custom variants

---

**Fouad System** - Advanced Linux Distribution

For support and updates, refer to your distribution's documentation.
