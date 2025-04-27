#!/bin/bash

# List of packages to install
PACKAGES=(
	hyprland
	hyprlock
	wl-clipboard
	wf-recorder
	rofi-wayland
	pavucontrol
	hyprland-qtutils
	dunst
	swaybg
	alacritty
	hyprcursor
	noto-fonts
	hyprpicker
	nwg-look
	jq
	gvfs
	mpv
	playerctl
	pamixer
	neovim
	brightnessctl
	power-profiles-daemon
	waybar
	papirus-icon-theme
	starship
	grim
	slurp
	thunar
	ripgrep
	xdg-desktop-portal-wlr
	xdg-desktop-portal-hyprland
	xdg-desktop-portal
)

# Function to install packages
install_packages() {
	echo "Updating package list..."
	sudo pacman -Syy

	echo "Installing packages..."
	sudo pacman -Syu -y "${PACKAGES[@]}"

	echo "Installation complete!"
}

# Run installation
install_packages
