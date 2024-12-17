#!/bin/bash

# Target resolutions for identifying monitors
TARGET_RESOLUTION1="355" # Vertical monitor
TARGET_RESOLUTION2="698" # Big monitor
TARGET_RESOLUTION3="344" # Laptop screen

# Variables to store detected monitor names
TARGET_MONITOR1=""
TARGET_MONITOR2=""
TARGET_MONITOR3=""

# Parse xrandr output to find monitors matching target resolutions
while read -r line; do
    if [[ $line =~ $TARGET_RESOLUTION1 ]]; then
        TARGET_MONITOR1=$(echo "$line" | awk '{print $NF}')
    fi
    if [[ $line =~ $TARGET_RESOLUTION2 ]]; then
        TARGET_MONITOR2=$(echo "$line" | awk '{print $NF}')
    fi
    if [[ $line =~ $TARGET_RESOLUTION3 ]]; then
        TARGET_MONITOR3=$(echo "$line" | awk '{print $NF}')
    fi
done <<< "$(xrandr --listmonitors)"

# Assign default values if monitors are not detected
TARGET_MONITOR1=${TARGET_MONITOR1:-"DP-2"}
TARGET_MONITOR2=${TARGET_MONITOR2:-"eDP-1"}
TARGET_MONITOR3=${TARGET_MONITOR3:-"eDP-1"}

# Output the monitor names for debugging
echo "Monitor 1: $TARGET_MONITOR1"
echo "Monitor 2: $TARGET_MONITOR2"
echo "Monitor 3: $TARGET_MONITOR3"

xrandr --output "$TARGET_MONITOR3" --primary

if [[ -n "$TARGET_MONITOR2" ]]; then
    xrandr --output "$TARGET_MONITOR2" --right-of "$TARGET_MONITOR3"
fi

xrandr --output "$TARGET_MONITOR1" --rotate "right" --right-of "$TARGET_MONITOR2"
xrandr --output "$TARGET_MONITOR1" --rotate "left" --right-of "$TARGET_MONITOR2"

# Set background image
feh --bg-fill /home/admin/Pictures/Background.jpg
