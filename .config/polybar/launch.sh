#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

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

# Launch Polybar, using default config location ~/.config/polybar/config
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [[ $m != $TARGET_MONITOR1 ]]; then
        MONITOR=$m polybar --reload top1 &
        MONITOR=$m polybar --reload top2 &
        MONITOR=$m polybar --reload top3 &
        MONITOR=$m polybar --reload top4 &
        MONITOR=$m polybar --reload top5 &
    else
        MONITOR=$m polybar --reload top0 &
        MONITOR=$m polybar --reload top1 &
    fi
    MONITOR=$m polybar --reload terminal &
    MONITOR=$m polybar --reload browser &
    MONITOR=$m polybar --reload email &
    MONITOR=$m polybar --reload ksnip &
    MONITOR=$m polybar --reload repos &
    MONITOR=$m polybar --reload documents &
    MONITOR=$m polybar --reload downloads &
    MONITOR=$m polybar --reload settings &
    MONITOR=$m polybar --reload bashrc &
    MONITOR=$m polybar --reload alacritty &
    MONITOR=$m polybar --reload polybar-config &
    MONITOR=$m polybar --reload i3-config &
    MONITOR=$m polybar --reload grep &
    MONITOR=$m polybar --reload sed &
    MONITOR=$m polybar --reload commit &
    MONITOR=$m polybar --reload zip &
    MONITOR=$m polybar --reload nvim &
    MONITOR=$m polybar --reload xkill &
    MONITOR=$m polybar --reload docker-clean &
done

echo "Bars launched..."
