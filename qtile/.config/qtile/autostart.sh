#!/bin/bash

xrandr --output eDP-1 --mode "1920x1080" --rate "60.01"

# Directory where your wallpapers are stored (adjust this path to your own)
WALLPAPER_DIR="~/Wallpapers"

# Get a random image file from the directory (supports jpg, jpeg, png)
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

# Apply the random wallpaper using feh
feh --bg-scale "$RANDOM_WALLPAPER"

picom &

flameshot &

nm-applet &

blueman-applet &

dunst &
