#!/bin/bash

# Set the card index (change this if the card index is different)
card_index=0
deadlocked=false

speakers_profile="HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
headphones_profile="HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)"

# Check if the speaker is muted
speakers_sink_name="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
speakers_muted=$(pacmd list-sinks | awk -v sink_name="$speakers_sink_name" '
  $0 ~ sink_name { found=1 }
  found && $1 == "muted:" { print $2; exit }
')

headphones_sink_name="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink"
headphones_muted=$(pacmd list-sinks | awk -v sink_name="$headphones_sink_name" '
  $0 ~ sink_name { found=1 }
  found && $1 == "muted:" { print $2; exit }
')

# Ensure the muted values are normalized (default to "yes" if empty)
speakers_muted=${speakers_muted:-yes}
headphones_muted=${headphones_muted:-yes}

# Get the current active profile
current_profile=$(pactl list cards | awk -v card_index="$card_index" '
  $0 ~ "Card #"card_index { found=1 }
  found && $1 == "Active" && $2 == "Profile:" { $1=""; $2=""; print $0; exit }
')

if [ "$current_profile" == "$headphones_profile" ]; then
    pactl set-card-profile $card_index "$speakers_profile"
else
    pactl set-card-profile $card_index "$headphones_profile"
fi
