#!/bin/bash

# Get temperature value
TEMP=$(sensors | grep -i 'CPUTIN' | awk '{print $2}' | tr -d '+°C')

# Remove decimal part if needed
TEMP_INT=$(printf "%.0f" "$TEMP")

# Set color based on thresholds
if (( $(echo "$TEMP > 60" | bc -l) )); then
  COLOR="#FF0000"  # Red for temperature > 60
elif (( $(echo "$TEMP > 50" | bc -l) )); then
  COLOR="#FFA500"  # White for temperature > 50
else
  COLOR="#FFFFFF"  # White for temperature <= 40
fi

# Output with the right format for i3blocks
echo "$TEMP_INT°C"
echo "$TEMP_INT°C"
echo "$COLOR"

exit 0