#!/bin/bash

# Update and upgrade system
sudo pacman -Syu --noconfirm

# Essential programs
ESSENTIAL_APPS=(
  "sddm"              # Display manager
  "dunst"             # Notification daemon
  "picom"             # Compositor
  "alacritty"         # Terminal emulator
  "bash"              # Shell
  "flameshot"         # Screenshot tool
  "grim"              # Screenshot tool for Wayland (optional)
  "spotify"           # Spotify client
  "brave-nightly-bin" # Brave browser from AUR
  "neovim"            # Neovim editor
  "vim"               # Vim editor
  "rust"              # Rust programming language
  "xorg-server"       # X11 server
  "xorg-xinit"        # Xorg init
  "feh"               # Wallpaper setter
  "rofi"              # Application launcher
  "nemo"
  "networkmanager"
  "imlib2"
  "network-manager-applet"
  "zed"
  "lutris"
  "micro"
)

# Fonts and emoji support
FONTS_APPS=(
  "nerd-fonts-complete"  # Nerd Fonts
  "ttf-dejavu"           # DejaVu Fonts
  "ttf-font-awesome"     # Font Awesome icons
  "ttf-jetbrains-mono"   # JetBrains Mono font
  "noto-fonts"           # Noto Fonts
  "noto-fonts-emoji"     # Emoji support
)

# Additional applications
EXTRA_APPS=(
  "xclip"           # Clipboard manager
  "btop"            # System monitor
  "curl"            # URL data transfers
  "wget"            # Network downloader
  "brightnessctl"   # Screen brightness control
  "alsa-utils"      # Audio utilities
  "nordic-theme"    # Nordic GTK theme
  "bluez"
  "bluez-utils"
  "blueman"
  "pamixer"
  "mirage"
  "mupdf"
)

# Installing essential programs
echo "Installing essential programs..."
sudo pacman -S --noconfirm ${ESSENTIAL_APPS[@]}

# Installing fonts and emoji support
echo "Installing fonts and emoji support..."
yay -S --noconfirm ${FONTS_APPS[@]}

# Installing additional applications via yay (AUR)
echo "Installing additional applications..."
yay -S --noconfirm ${EXTRA_APPS[@]}

# Clone your custom DWM configuration from GitHub to ~/.config/ste-dwm
REPO_DIR="$HOME/.config/ste-dwm"
GITHUB_REPO="https://github.com/rishabh181104/ste-dwm.git"

echo "Cloning your custom DWM setup into ~/.config/ste-dwm..."
if [ -d "$REPO_DIR" ]; then
  echo "Removing existing directory..."
  rm -rf "$REPO_DIR"
fi
git clone "$GITHUB_REPO" "$REPO_DIR"

# Build and install DWM from the cloned repository path ~/.config/ste-dwm/ste-dwm/
cd "$REPO_DIR/ste-dwm" || exit
sudo make clean install

# Clone your wallpapers repository to ~/Wallpapers
WALLPAPER_REPO="https://github.com/rishabh181104/Wallpapers.git"
WALLPAPER_DIR="$HOME/Wallpapers"

echo "Cloning your wallpaper repository to ~/Wallpapers..."
if [ -d "$WALLPAPER_DIR" ]; then
  echo "Removing existing directory..."
  rm -rf "$WALLPAPER_DIR"
fi
git clone "$WALLPAPER_REPO" "$WALLPAPER_DIR"

# Copy configuration files from ~/.config/ste-dwm/config to their respective locations
CONFIG_DIRS=("alacritty" "dunst" "gtk-3.0" "gtk-4.0" "picom" "rofi")

echo "Copying configuration files to ~/.config..."
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$REPO_DIR/config/$dir" ]; then
    mkdir -p "$HOME/.config/$dir"
    cp -r "$REPO_DIR/config/$dir/"* "$HOME/.config/$dir/"
    echo "Copied $dir configuration to ~/.config/$dir/"
  fi
done

# Ensure the run.sh script is executable
RUN_SCRIPT="$REPO_DIR/scripts/run.sh"
if [ -f "$RUN_SCRIPT" ]; then
  chmod +x "$RUN_SCRIPT"
else
  echo "Warning: $RUN_SCRIPT not found! Ensure it exists and contains the necessary commands to launch DWM."
fi

# Set Nordic theme for GTK 3 and GTK 4
echo "Setting Nordic theme for GTK 3 and GTK 4..."
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
echo -e "[Settings]\ngtk-theme-name=Nordic" | tee "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

# Create a custom desktop entry for DWM in SDDM
echo "Creating a custom desktop entry for DWM..."
sudo bash -c "cat <<EOF > /usr/share/xsessions/ste-dwm.desktop
[Desktop Entry]
Name=Ste-Dwm
Comment=dwm made beautiful
Exec=$RUN_SCRIPT
Type=Application
EOF"

# Enable and start SDDM
echo "Enabling SDDM..."
sudo systemctl enable sddm
sudo systemctl start sddm

echo "Installation and configuration completed!"
echo "Reboot your system to apply changes and start using SDDM with your custom DWM setup."

