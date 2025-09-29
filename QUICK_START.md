# Fouad System Branding - Quick Start Guide

## 🎯 Quick Reference

### What's Included

| Asset Type | Files | Resolution | Format |
|------------|-------|------------|--------|
| **Logos** | 4 files | 1024×1024 | SVG + PNG |
| **Wallpapers** | 2 files | 4K & 1080p | PNG |
| **Boot Splash** | 1 file | 1920×1080 | PNG |
| **Installer BG** | 1 file | 1920×1080 | PNG |

---

## ⚡ 5-Minute Setup

### 1. Set Desktop Wallpaper
```bash
# Copy to backgrounds folder
sudo cp wallpapers/fouad_system_wallpaper_*.png /usr/share/backgrounds/

# Set as wallpaper (GNOME example)
gsettings set org.gnome.desktop.background picture-uri \
  file:///usr/share/backgrounds/fouad_system_wallpaper_4k.png
```

### 2. Install Boot Splash
```bash
# Copy boot splash
sudo mkdir -p /usr/share/plymouth/themes/fouad-system
sudo cp boot_splash/fouad_system_boot_splash.png \
  /usr/share/plymouth/themes/fouad-system/background.png

# Set Plymouth theme (requires theme configuration - see INSTALLATION_GUIDE.md)
```

### 3. Set GRUB Background
```bash
# Copy to GRUB directory
sudo cp boot_splash/fouad_system_boot_splash.png /boot/grub/fouad-grub.png

# Add to /etc/default/grub:
# GRUB_BACKGROUND="/boot/grub/fouad-grub.png"

# Update GRUB
sudo update-grub
```

### 4. Add System Logos
```bash
# Copy logos to system
sudo mkdir -p /usr/share/pixmaps/fouad-system
sudo cp logos/*.{png,svg} /usr/share/pixmaps/fouad-system/
```

---

## 🎨 Color Reference

```css
Primary:    #00B4D8  /* Cyan Blue */
Secondary:  #8A2BE2  /* Blue Violet */
Accent:     #00FFFF  /* Bright Cyan */
Dark BG:    #0A0F19  /* Deep Dark Blue */
```

---

## 📁 File Locations

```
├── logos/
│   ├── fouad_system_logo_dark.svg     ← Use on dark backgrounds
│   ├── fouad_system_logo_light.svg    ← Use on light backgrounds
│   ├── fouad_system_logo_dark.png     ← PNG version (dark)
│   └── fouad_system_logo_light.png    ← PNG version (light)
├── wallpapers/
│   ├── fouad_system_wallpaper_4k.png      ← 3840×2160
│   └── fouad_system_wallpaper_1080p.png   ← 1920×1080
├── boot_splash/
│   └── fouad_system_boot_splash.png       ← Boot screen
└── installer/
    └── fouad_system_installer_bg.png      ← Installer background
```

---

## 🚀 Regenerate Assets

If you need to modify or regenerate PNG assets:

```bash
# Install Pillow (if not already installed)
pip3 install Pillow

# Run the generator script
python3 create_assets.py
```

The script will recreate all PNG files while preserving SVG originals.

---

## 📖 Full Documentation

- **README.md** - Complete branding specifications and design philosophy
- **INSTALLATION_GUIDE.md** - Detailed installation instructions for all components
- **PREVIEW.html** - Visual preview of all assets (open in browser)

---

## ✨ Key Features

✅ **Professional Design** - Enterprise-grade aesthetics  
✅ **Modern & Minimal** - Clean, focused visual language  
✅ **Fully Scalable** - Vector logos + high-res rasters  
✅ **Unique Identity** - Distinct from other distributions  
✅ **Complete Package** - Everything needed for full branding  
✅ **Easy Integration** - Works with major desktop environments  

---

## 🔗 Usage Tips

### Logo Usage
- Always use appropriate variant (dark/light) for your background
- Maintain aspect ratio when scaling
- Keep clear space around logo (minimum 10% of logo width)

### Wallpaper
- Left side is kept clear for desktop icons
- Works best with dark-themed desktops
- 4K version recommended for high-DPI displays

### Boot Splash
- Centered design works across resolutions
- Includes progress bar indicator area
- Compatible with Plymouth and GRUB

---

## 🎯 Common Use Cases

### Desktop Environment
1. Set wallpaper from `wallpapers/`
2. Copy logos to `/usr/share/pixmaps/`
3. Configure login manager with background

### Distribution ISO
1. Configure installer with `installer/` background
2. Set boot splash from `boot_splash/`
3. Include wallpapers in default package

### Branding Materials
1. Use SVG logos for print materials
2. Use PNG logos for web and digital media
3. Reference color palette for consistent theme

---

## 🌟 Need Help?

1. Check **INSTALLATION_GUIDE.md** for detailed instructions
2. Review **README.md** for design specifications
3. Open **PREVIEW.html** to see all assets visually

---

**Fouad System** - Advanced Linux Distribution  
Professional • Modern • Distinct
