#!/bin/bash

# Define variables
retries=20
delay=5
devices=("Wacom HID 5201 Finger" "Wacom HID 5201 Pen Pen (0x80a104ec)")  # List of device IDs to map

# Function to run xinput commands
run_xinput() {
    for device in "${devices[@]}"; do
        if ! xinput --map-to-output $device eDP-1; then
            echo "Failed to map device $device to output eDP-1"
            return 1  # Return failure if any command fails
        fi
    done
    return 0  # Return success if all commands succeed
}

# Retry logic
for ((i=1; i<=retries; i++)); do
    echo "Attempt $i of $retries..."
    if run_xinput; then
        echo "Successfully mapped all devices."
        exit 0  # Exit if successful
    fi
    echo "Retrying in $delay seconds..."
    sleep "$delay"
done
