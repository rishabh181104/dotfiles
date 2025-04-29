#!/bin/bash
# Change to your wallpapers directory:
WALLPAPERS="$HOME/Wallpapers/Pictures/"
# Ensure swww daemon is running:
pgrep -x swww-daemon >/dev/null || swww-daemon
# Select a random JPG:
IMG=$(find "$WALLPAPERS" -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n1)
# Set the wallpaper with a transition:
swww img "$IMG" --transition-type any --transition-fps 60 --transition-step 2
# Generate color scheme from the wallpaper:
rswal "$IMG"

