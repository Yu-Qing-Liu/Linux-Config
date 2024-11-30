#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch Polybar, using default config location ~/.config/polybar/config
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [[ $m != "DP-2" ]]; then
        MONITOR=$m polybar --reload top1 &
        MONITOR=$m polybar --reload top2 &
        MONITOR=$m polybar --reload top3 &
        MONITOR=$m polybar --reload bottom1 &
    else
        MONITOR=$m polybar --reload top0 &
        MONITOR=$m polybar --reload bottom0 &
    fi
done

echo "Bars launched..."
