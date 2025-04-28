#!/bin/bash

# Simple TTY Autologin Setup Script

set -e

USER_NAME="$(whoami)"

echo "Setting up TTY autologin for user: $USER_NAME..."

# Create the override file for getty@tty1
sudo touch /etc/systemd/system/autologin@tty1.service

sudo tee /etc/systemd/system/autologin@tty1.service > /dev/null <<EOF
[Unit]
Description=Autologin on tty1
After=systemd-user-sessions.service

[Service]
ExecStart=-/sbin/agetty --autologin USER_NAME --noclear %I 38400 linux
Type=simple
TTYPath=/dev/tty1
Restart=always
RestartSec=0

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and restart getty service
echo "Reloading systemd..."
sudo systemctl daemon-reexec

echo "✅ TTY autologin is now set up for $USER_NAME!"
echo "You can reboot to see it in action."
