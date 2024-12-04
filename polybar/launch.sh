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
        MONITOR=$m polybar --reload top4 &
        MONITOR=$m polybar --reload top5 &
    else
        MONITOR=$m polybar --reload top0 &
    fi
    MONITOR=$m polybar --reload terminal &
    MONITOR=$m polybar --reload browser &
    MONITOR=$m polybar --reload email &
    MONITOR=$m polybar --reload ksnip &
    MONITOR=$m polybar --reload repos &
    MONITOR=$m polybar --reload downloads &
    MONITOR=$m polybar --reload settings &
    MONITOR=$m polybar --reload bashrc &
    MONITOR=$m polybar --reload grep &
    MONITOR=$m polybar --reload sed &
    MONITOR=$m polybar --reload commit &
    MONITOR=$m polybar --reload zip &
done

echo "Bars launched..."
