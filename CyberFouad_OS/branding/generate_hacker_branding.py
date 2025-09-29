#!/usr/bin/env python3
"""
CyberFouad OS - Complete Branding & Wallpaper Generator
Creates hacker-themed logos, icons, and 20 unique cybersecurity wallpapers
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageChops
import math
import random
import os

# Hacker-themed color schemes
COLOR_SCHEMES = {
    'matrix': {
        'bg': (0, 0, 0),
        'primary': (0, 255, 65),
        'secondary': (0, 200, 50),
        'accent': (50, 255, 100),
        'glow': (0, 255, 100)
    },
    'cyber_blue': {
        'bg': (5, 10, 20),
        'primary': (0, 200, 255),
        'secondary': (0, 150, 255),
        'accent': (100, 220, 255),
        'glow': (50, 200, 255)
    },
    'red_alert': {
        'bg': (10, 0, 0),
        'primary': (255, 0, 50),
        'secondary': (200, 0, 40),
        'accent': (255, 50, 100),
        'glow': (255, 0, 80)
    },
    'purple_haze': {
        'bg': (15, 0, 25),
        'primary': (200, 0, 255),
        'secondary': (150, 0, 200),
        'accent': (220, 100, 255),
        'glow': (180, 50, 255)
    },
    'dark_orange': {
        'bg': (15, 10, 0),
        'primary': (255, 140, 0),
        'secondary': (200, 100, 0),
        'accent': (255, 180, 50),
        'glow': (255, 150, 30)
    }
}

def create_directories():
    """Create output directory structure"""
    dirs = [
        'output/logos',
        'output/wallpapers',
        'output/boot_splash',
        'output/icons',
        'output/installer'
    ]
    for d in dirs:
        os.makedirs(d, exist_ok=True)

def draw_skull_logo(draw, center_x, center_y, size, color):
    """Draw stylized skull/hacker symbol"""
    # Skull outline
    skull_width = size
    skull_height = int(size * 1.2)
    
    # Head (rounded rectangle)
    head_top = center_y - skull_height//2
    head_left = center_x - skull_width//2
    draw.ellipse([head_left, head_top, head_left + skull_width, head_top + skull_height*0.7],
                 fill=color, outline=color)
    
    # Eyes (glowing effect)
    eye_y = center_y - size * 0.2
    eye_size = size * 0.2
    eye_glow = size * 0.3
    
    # Left eye with glow
    left_eye_x = center_x - size * 0.25
    for i in range(5):
        alpha = 50 - i * 10
        glow_size = eye_glow - i * (eye_glow - eye_size) / 5
        if len(color) == 4:
            glow_color = (*color[:3], alpha)
        else:
            glow_color = (*color, alpha)
        draw.ellipse([left_eye_x - glow_size/2, eye_y - glow_size/2,
                     left_eye_x + glow_size/2, eye_y + glow_size/2],
                    fill=glow_color)
    
    # Right eye with glow
    right_eye_x = center_x + size * 0.25
    for i in range(5):
        alpha = 50 - i * 10
        glow_size = eye_glow - i * (eye_glow - eye_size) / 5
        if len(color) == 4:
            glow_color = (*color[:3], alpha)
        else:
            glow_color = (*color, alpha)
        draw.ellipse([right_eye_x - glow_size/2, eye_y - glow_size/2,
                     right_eye_x + glow_size/2, eye_y + glow_size/2],
                    fill=glow_color)

def draw_binary_rain(draw, width, height, color, density=50):
    """Draw Matrix-style binary rain effect"""
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 12)
    except:
        font = ImageFont.load_default()
    
    for _ in range(density):
        x = random.randint(0, width)
        y = random.randint(0, height)
        text = random.choice(['0', '1'])
        alpha = random.randint(50, 200)
        if len(color) == 3:
            text_color = (*color, alpha)
        else:
            text_color = (*color[:3], alpha)
        draw.text((x, y), text, fill=text_color, font=font)

def draw_circuit_pattern(draw, width, height, color, density=30):
    """Draw circuit board pattern"""
    for _ in range(density):
        x1 = random.randint(0, width)
        y1 = random.randint(0, height)
        
        # Horizontal or vertical line
        if random.choice([True, False]):
            x2 = x1 + random.randint(50, 200)
            y2 = y1
        else:
            x2 = x1
            y2 = y1 + random.randint(50, 200)
        
        alpha = random.randint(30, 100)
        if len(color) == 3:
            line_color = (*color, alpha)
        else:
            line_color = (*color[:3], alpha)
        
        draw.line([(x1, y1), (x2, y2)], fill=line_color, width=1)
        
        # Add node at start
        draw.ellipse([x1-3, y1-3, x1+3, y1+3], fill=line_color)

def draw_hexagon_grid(draw, width, height, color, size=50, opacity=30):
    """Draw hexagonal grid pattern"""
    hex_height = int(size * math.sqrt(3))
    
    for row in range(-1, height // hex_height + 2):
        for col in range(-1, width // size + 2):
            x = col * size * 1.5
            y = row * hex_height + (hex_height // 2 if col % 2 else 0)
            
            if 0 <= x < width and 0 <= y < height:
                # Draw hexagon
                points = []
                for i in range(6):
                    angle = math.radians(60 * i)
                    px = x + size * 0.5 * math.cos(angle)
                    py = y + size * 0.5 * math.sin(angle)
                    points.append((px, py))
                
                if len(color) == 3:
                    hex_color = (*color, opacity)
                else:
                    hex_color = (*color[:3], opacity)
                    
                draw.polygon(points, outline=hex_color)

def create_hacker_logo(filename, size=1024, theme='matrix'):
    """Create main hacker-themed logo"""
    colors = COLOR_SCHEMES[theme]
    
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, 'RGBA')
    
    # Background circle with glow
    for i in range(20, 0, -2):
        alpha = int(255 * (i / 20) * 0.3)
        glow_color = (*colors['glow'], alpha)
        radius = size * 0.45 + i * 3
        draw.ellipse([size/2 - radius, size/2 - radius,
                     size/2 + radius, size/2 + radius],
                    fill=glow_color)
    
    # Main circle
    circle_color = (*colors['primary'], 200)
    radius = size * 0.4
    draw.ellipse([size/2 - radius, size/2 - radius,
                 size/2 + radius, size/2 + radius],
                outline=circle_color, width=4)
    
    # Skull/hacker symbol
    skull_color = (*colors['primary'], 255)
    draw_skull_logo(draw, size/2, size/2 * 0.9, size * 0.3, skull_color)
    
    # Binary code ring
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf", 
                                  int(size * 0.03))
    except:
        font = ImageFont.load_default()
    
    binary_text = "01000011 01011001 01000010 01000101 01010010"
    bbox = draw.textbbox((0, 0), binary_text, font=font)
    text_width = bbox[2] - bbox[0]
    text_x = (size - text_width) / 2
    text_y = size * 0.7
    
    text_color = (*colors['accent'], 200)
    draw.text((text_x, text_y), binary_text, fill=text_color, font=font)
    
    # System name
    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 
                                       int(size * 0.08))
    except:
        title_font = font
    
    title = "CYBERFOUAD"
    bbox = draw.textbbox((0, 0), title, font=title_font)
    title_width = bbox[2] - bbox[0]
    title_x = (size - title_width) / 2
    title_y = size * 0.78
    
    # Title with shadow
    shadow_color = (0, 0, 0, 150)
    draw.text((title_x + 3, title_y + 3), title, fill=shadow_color, font=title_font)
    draw.text((title_x, title_y), title, fill=(*colors['primary'], 255), font=title_font)
    
    # Subtitle
    try:
        subtitle_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 
                                          int(size * 0.03))
    except:
        subtitle_font = font
    
    subtitle = "UNLEASH YOUR CYBER POWER"
    bbox = draw.textbbox((0, 0), subtitle, font=subtitle_font)
    subtitle_width = bbox[2] - bbox[0]
    subtitle_x = (size - subtitle_width) / 2
    subtitle_y = title_y + int(size * 0.1)
    
    draw.text((subtitle_x, subtitle_y), subtitle, 
             fill=(*colors['accent'], 180), font=subtitle_font)
    
    img.save(filename, 'PNG')
    print(f"✓ Created: {filename}")

def create_wallpaper_matrix_rain(filename, width, height):
    """Wallpaper 1: Matrix digital rain"""
    colors = COLOR_SCHEMES['matrix']
    
    img = Image.new('RGB', (width, height), colors['bg'])
    overlay = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay, 'RGBA')
    
    # Dense binary rain
    draw_binary_rain(draw, width, height, colors['primary'], density=200)
    
    # Logo watermark
    logo_size = int(height * 0.3)
    logo_x = int(width * 0.75)
    logo_y = int(height * 0.5)
    
    # Glowing effect
    for i in range(30, 0, -3):
        alpha = int(255 * (i / 30) * 0.1)
        glow_color = (*colors['glow'], alpha)
        radius = logo_size * 0.5 + i
        draw.ellipse([logo_x - radius, logo_y - radius,
                     logo_x + radius, logo_y + radius],
                    fill=glow_color)
    
    # Skull symbol
    draw_skull_logo(draw, logo_x, logo_y, logo_size, (*colors['primary'], 100))
    
    # Text
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 
                                  int(height * 0.04))
    except:
        font = ImageFont.load_default()
    
    draw.text((int(width * 0.03), int(height * 0.95)), "CyberFouad OS", 
             fill=(*colors['primary'], 150), font=font)
    
    img = Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB')
    img.save(filename, 'PNG', quality=95)
    print(f"✓ Created: {filename}")

def create_wallpaper_circuit_board(filename, width, height):
    """Wallpaper 2: Circuit board design"""
    colors = COLOR_SCHEMES['cyber_blue']
    
    img = Image.new('RGB', (width, height), colors['bg'])
    overlay = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay, 'RGBA')
    
    # Circuit patterns
    draw_circuit_pattern(draw, width, height, colors['primary'], density=80)
    
    # Hexagon grid
    draw_hexagon_grid(draw, width, height, colors['secondary'], size=60, opacity=40)
    
    # Logo
    logo_x = int(width * 0.8)
    logo_y = int(height * 0.5)
    logo_size = int(height * 0.35)
    
    draw_skull_logo(draw, logo_x, logo_y, logo_size, (*colors['primary'], 120))
    
    # Title
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 
                                  int(height * 0.05))
    except:
        font = ImageFont.load_default()
    
    draw.text((int(width * 0.03), int(height * 0.93)), "CyberFouad OS - Circuit Master", 
             fill=(*colors['primary'], 180), font=font)
    
    img = Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB')
    img.save(filename, 'PNG', quality=95)
    print(f"✓ Created: {filename}")

def create_wallpaper_hex_grid(filename, width, height):
    """Wallpaper 3: Hexagonal grid pattern"""
    colors = COLOR_SCHEMES['purple_haze']
    
    img = Image.new('RGB', (width, height), colors['bg'])
    overlay = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay, 'RGBA')
    
    # Large hexagon grid
    draw_hexagon_grid(draw, width, height, colors['primary'], size=80, opacity=60)
    draw_hexagon_grid(draw, width, height, colors['secondary'], size=40, opacity=40)
    
    # Glowing nodes
    for _ in range(30):
        x = random.randint(0, width)
        y = random.randint(0, height)
        node_size = random.randint(5, 15)
        
        for i in range(10, 0, -1):
            alpha = int(255 * (i / 10) * 0.5)
            draw.ellipse([x - node_size - i, y - node_size - i,
                         x + node_size + i, y + node_size + i],
                        fill=(*colors['glow'], alpha))
    
    # Brand text
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 
                                  int(height * 0.045))
    except:
        font = ImageFont.load_default()
    
    draw.text((int(width * 0.03), int(height * 0.94)), "CyberFouad OS - Hexagonal Protocol", 
             fill=(*colors['primary'], 170), font=font)
    
    img = Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB')
    img.save(filename, 'PNG', quality=95)
    print(f"✓ Created: {filename}")

def generate_all_wallpapers():
    """Generate all 20 unique wallpapers"""
    print("\n" + "="*60)
    print("Generating 20 Unique Cybersecurity Wallpapers...")
    print("="*60 + "\n")
    
    # Resolutions
    resolutions = [(3840, 2160), (1920, 1080)]
    themes = list(COLOR_SCHEMES.keys())
    
    wallpaper_count = 1
    
    for res_name, (width, height) in [('4k', (3840, 2160)), ('1080p', (1920, 1080))]:
        for theme_idx, theme in enumerate(themes):
            # Type 1: Matrix rain
            create_wallpaper_matrix_rain(
                f'output/wallpapers/cyberfouad_wallpaper_{wallpaper_count:02d}_{theme}_matrix_{res_name}.png',
                width, height
            )
            wallpaper_count += 1
            
            # Type 2: Circuit board
            create_wallpaper_circuit_board(
                f'output/wallpapers/cyberfouad_wallpaper_{wallpaper_count:02d}_{theme}_circuit_{res_name}.png',
                width, height
            )
            wallpaper_count += 1
            
            if wallpaper_count > 20:
                break
        if wallpaper_count > 20:
            break

def main():
    """Main generation function"""
    print("\n" + "="*70)
    print(" "*15 + "CYBERFOUAD OS - BRANDING GENERATOR")
    print("="*70 + "\n")
    
    create_directories()
    
    print("[1/3] Generating Logos...")
    for theme in ['matrix', 'cyber_blue', 'red_alert']:
        create_hacker_logo(f'output/logos/cyberfouad_logo_{theme}.png', 1024, theme)
    
    print("\n[2/3] Generating Wallpapers (this may take a few minutes)...")
    generate_all_wallpapers()
    
    print("\n[3/3] Creating Boot Splash...")
    create_hacker_logo('output/boot_splash/boot_splash.png', 1920, 'matrix')
    
    print("\n" + "="*70)
    print("✓ ALL BRANDING ASSETS GENERATED SUCCESSFULLY!")
    print("="*70)
    print("\nOutput directory: output/")
    print("  ├── logos/           - System logos")
    print("  ├── wallpapers/      - 20 unique wallpapers")
    print("  ├── boot_splash/     - Boot screen")
    print("  └── icons/           - System icons")
    print("\n" + "="*70 + "\n")

if __name__ == "__main__":
    main()
