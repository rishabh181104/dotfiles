#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Update and install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    if command_exists apt; then
        sudo apt update
        sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
    elif command_exists dnf; then
        sudo dnf install -y ninja-build gettext libtool autoconf automake cmake gcc-c++ make pkgconfig unzip curl doxygen
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm ninja gettext libtool autoconf automake cmake gcc pkg-config unzip curl doxygen
    else
        echo "Unsupported package manager. Please install the dependencies manually."
        exit 1
    fi
}

# Clone and build Neovim from source
build_neovim() {
    echo "Cloning Neovim repository..."
    if [ -d "$HOME/neovim" ]; then
        echo "Directory ~/neovim already exists. Pulling latest changes..."
        cd "$HOME/neovim" || exit
        git pull
    else
        git clone https://github.com/neovim/neovim.git "$HOME/neovim"
        cd "$HOME/neovim" || exit
    fi

    echo "Building Neovim..."
    make CMAKE_BUILD_TYPE=Release

    echo "Installing Neovim to /usr/local..."
    sudo make install
}

# Add /usr/local/bin to PATH if missing
ensure_path() {
    if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
        echo "Adding /usr/local/bin to PATH..."
        echo 'export PATH="/usr/local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="/usr/local/bin:$PATH"' >> "$HOME/.zshrc"
        export PATH="/usr/local/bin:$PATH"
    fi
}

# Main script
main() {
    echo "Starting Neovim installation script..."

    # Install dependencies if needed
    install_dependencies

    # Clone, build, and install Neovim
    build_neovim

    # Ensure /usr/local/bin is in PATH
    ensure_path

    # Verify installation
    if command_exists nvim; then
        echo "Neovim successfully installed. Version:"
        nvim --version
    else
        echo "Failed to install Neovim. Please check the logs."
        exit 1
    fi
}

# Run the script
main

