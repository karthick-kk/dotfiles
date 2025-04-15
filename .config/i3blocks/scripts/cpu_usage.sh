#!/bin/bash

# Get CPU usage
CPU=$(top -bn2 | grep "Cpu(s)" | tail -n 1 | awk '{print 100 - $8}')

# Round to nearest integer for display
CPU_INT=$(printf "%.0f" "$CPU")

# Set color based on thresholds
if (( $(echo "$CPU > 80" | bc -l) )); then
  COLOR="#FF0000"  # Red for CPU usage > 80%
elif (( $(echo "$CPU > 50" | bc -l) )); then
  COLOR="#FFFF00"  # Yellow for CPU usage > 50%
else
  COLOR="#FFFFFF"  # Green for CPU usage <= 50%
fi

# Output with the right format for i3blocks
echo "$CPU_INT%"
echo "$CPU_INT%"
echo "$COLOR"

exit 0