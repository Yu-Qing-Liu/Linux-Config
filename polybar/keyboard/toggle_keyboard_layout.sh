#!/bin/bash

# Get the current layout
current_layout=$(setxkbmap -query | grep layout | awk '{print $2}')

# Toggle between 'us' and 'fr'
if [ "$current_layout" = "us" ]; then
    setxkbmap ca
else
    setxkbmap us
fi
