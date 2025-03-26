#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/ste-dwm/scripts/bar_themes/onedark

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c$black^ ^b$green^ CPU"
	printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
	# Initialize updates as 0 instead of empty string
	updates=0

	if command -v xbps-install &> /dev/null; then
		# Void Linux
		updates=$({ timeout 60 sudo xbps-install -un 2>/dev/null || true; } | wc -l)
	elif command -v checkupdates &> /dev/null; then
		# Arch Linux
		updates=$({ timeout 60 checkupdates 2>/dev/null || true; } | wc -l)
	elif command -v apt &> /dev/null; then
		# Debian/Ubuntu
		updates=$(( $({ timeout 60 apt list --upgradable 2>/dev/null || true; } | grep -c '^') - 1 ))
	elif command -v zypper &> /dev/null; then
		# openSUSE Tumbleweed
		updates=$({ timeout 60 sudo zypper list-updates -i 2>/dev/null || true; } | grep -c '^i')
	fi

  # Ensure updates is treated as a number and compare properly
  updates=${updates:-0}  # Set to 0 if empty
  if [ "$updates" -eq 0 ]; then
	  printf "  ^c$green^    Fully Updated"
  else
	  printf "  ^c$green^    %s updates" "$updates"
  fi
}

battery() {
	get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
	get_status="$(cat /sys/class/power_supply/BAT0/status)"

	if [ "$get_status" = "Charging" ]; then
		printf "^c$green^⚡%s%%" "$get_capacity"
	elif [ "$get_status" = "Discharging" ]; then
		if [ "$get_capacity" -ge 20 ]; then
			printf "^c$blue^%s%%" "$get_capacity"
		else
			printf "^c$red^%s%% ❗" "$get_capacity"
		fi
	else
		printf "^c$blue^%s%%" "$get_capacity"
	fi
}

brightness() {
	# Get the current brightness percentage
	current_brightness=$(brightnessctl g)
	max_brightness=$(brightnessctl m)
	brightness_percent=$((current_brightness * 100 / max_brightness))
	printf "^c$red^   "
	printf "^c$red^%d%%\n" "$brightness_percent"
}

mem() {
	printf "^c$blue^^b$black^  "
	printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

internet_speed() {
	# Get current RX and TX bytes
	rx1=$(cat /sys/class/net/[ew]*/statistics/rx_bytes | awk '{sum += $1} END {print sum}')
	tx1=$(cat /sys/class/net/[ew]*/statistics/tx_bytes | awk '{sum += $1} END {print sum}')

	sleep 1  # Wait for 1 second

  # Get updated RX and TX bytes
  rx2=$(cat /sys/class/net/[ew]*/statistics/rx_bytes | awk '{sum += $1} END {print sum}')
  tx2=$(cat /sys/class/net/[ew]*/statistics/tx_bytes | awk '{sum += $1} END {print sum}')

  # Calculate speed in KB/s
  rx_speed=$(( (rx2 - rx1) / 1024 ))
  tx_speed=$(( (tx2 - tx1) / 1024 ))

  printf "^c$black^ ^b$blue^   ^d^%s" " ^c$blue^↓${rx_speed}KB/s ↑${tx_speed}KB/s"
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$black^^b$blue^ $(date '+%I:%M %p')  "
}

update_interval=1
pkg_check_interval=60 # Check for updates every hour

updates=$(pkg_updates)  # Initial check for updates
last_update_time=$SECONDS

while true; do
	# Get the current time
	current_time=$SECONDS

  # Update all values except package updates every iteration
  bat=$(battery)
  bright=$(brightness)
  cpu_info=$(cpu)
  mem_info=$(mem)
  net_speed=$(internet_speed)
  time=$(clock)

  # Update package information if enough time has passed
  if ((current_time - last_update_time >= pkg_check_interval)); then
	  updates=$(pkg_updates)
	  last_update_time=$current_time
  fi

  # Update the status bar
  xsetroot -name "$updates $bat $bright $cpu_info $mem_info $net_speed $time"

  # Calculate how long to sleep
  end_time=$SECONDS
  sleep_time=$((update_interval - (end_time - current_time)))

  # Only sleep if there's time left
  if ((sleep_time > 0)); then
	  sleep $sleep_time
  fi
done
