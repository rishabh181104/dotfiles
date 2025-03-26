#!/bin/bash

set -e

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
FONT_DIR="$HOME/.local/share/fonts/NerdFonts"

install_manual() {
	echo "Manually installing MesloLGS Nerd Font..."
	mkdir -p "$FONT_DIR"
	temp_dir=$(mktemp -d)
	cd "$temp_dir"
	curl -LO "$FONT_URL"
	unzip Meslo.zip -d "$FONT_DIR"
	rm -f Meslo.zip
	rm -rf "$temp_dir"
	fc-cache -fv
	echo "MesloLGS Nerd Font installed successfully!"
}

install_manual

