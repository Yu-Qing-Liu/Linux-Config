#!/bin/bash

TARGET_RESOLUTION1="355" # vertical monitor
TARGET_RESOLUTION2="698" # big monitor
TARGET_RESOLUTION3="344" # laptop screen
TARGET_MONITOR1=""
TARGET_MONITOR2=""
TARGET_MONITOR3=""

while read -r line; do
    if [[ $line =~ $TARGET_RESOLUTION1 ]]; then
        TARGET_MONITOR1=$(echo $line | awk '{print $NF}')
    fi
    if [[ $line =~ $TARGET_RESOLUTION2 ]]; then
        TARGET_MONITOR2=$(echo $line | awk '{print $NF}')
    fi
    if [[ $line =~ $TARGET_RESOLUTION3 ]]; then
        TARGET_MONITOR3=$(echo $line | awk '{print $NF}')
    fi
done <<< "$(xrandr --listmonitors)"

if [ -n "$TARGET_MONITOR1" ]; then
    xrandr --output "$TARGET_MONITOR1" --rotate "left" --right-of "$TARGET_MONITOR2"
fi

if [ -n "$TARGET_MONITOR2" ]; then
    xrandr --output "$TARGET_MONITOR2" --right-of "$TARGET_MONITOR3"
fi

if [ -n "$TARGET_MONITOR3" ]; then
    xrandr --output "$TARGET_MONITOR3" --primary
fi

feh --bg-fill /home/admin/Pictures/Background.jpg
