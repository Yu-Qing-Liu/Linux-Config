#!/bin/bash

# Get the highest current workspace number
highest_workspace=$(i3-msg -t get_workspaces | jq '.[] | .num' | sort -nr | head -n 1)

# Calculate the next workspace number
next_workspace=$((highest_workspace + 1))

# Switch to the next workspace
i3-msg workspace $next_workspace
