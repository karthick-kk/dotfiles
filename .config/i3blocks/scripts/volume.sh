#!/bin/bash

# Get volume info from amixer
volume_info=$(amixer get Master | tail -n1)
volume=$(echo "$volume_info" | grep -Po '\[\K[0-9]+(?=%\])' | head -1)
mute=$(echo "$volume_info" | grep -o '\[off\]' || echo "")

# Handle mouse events for volume control
case $BLOCK_BUTTON in
    4) amixer -q set Master 5%+ unmute ;; # Scroll up, increase volume
    5) amixer -q set Master 5%- unmute ;; # Scroll down, decrease volume
    1) amixer -q set Master toggle ;; # Left click, toggle mute
esac

# Choose icon based on volume level and mute status
if [[ $mute ]]; then
    icon="🔇"
    color="#FF0000"
elif (( volume == 0 )); then
    icon="🔈"
    color="#FFFFFF"
elif (( volume < 50 )); then
    icon="🔉"
    color="#FFFFFF"
else
    icon="🔊"
    color="#FFFFFF"
fi

# Output formatted result
echo "<span color='$color'><span font_size='large'>$icon</span>:</span> ${volume}%"

exit 0