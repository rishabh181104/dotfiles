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
After=systemd-user-sessions.service getty.target
Before=getty@tty1.service

[Service]
ExecStart=-/sbin/agetty --autologin ste --noclear --keep-baud tty1 38400 linux
Restart=always
RestartSec=0
Type=idle
StandardInput=tty
StandardOutput=tty
StandardError=tty
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes
KillMode=process

[Install]
WantedBy=multi-user.target

EOF

# Reload systemd and restart getty service
echo "Reloading systemd..."
sudo systemctl daemon-reexec

echo "✅ TTY autologin is now set up for $USER_NAME!"
echo "You can reboot to see it in action."
