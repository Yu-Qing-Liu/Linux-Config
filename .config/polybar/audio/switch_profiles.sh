#!/bin/bash

# Set the card index (change this if the card index is different)
card_index=0
deadlocked=false

speakers_profile="HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
headphones_profile="HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)"

# Get the current active profile
current_profile=$(pactl list cards | awk -v card_index="$card_index" '
  $0 ~ "Card #"card_index { found=1 }
  found && $1 == "Active" && $2 == "Profile:" { $1=""; $2=""; print $0; exit }
' | xargs)

if [[ "$current_profile" == "$headphones_profile" ]]; then
    pactl set-card-profile $card_index "$speakers_profile"
else
    pactl set-card-profile $card_index "$headphones_profile"
fi
