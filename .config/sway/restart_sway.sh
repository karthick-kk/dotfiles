#!/bin/bash

# Script to apply Sway gaps configuration and test different values

# Reload Sway configuration
swaymsg reload

# Wait for configuration to reload
sleep 0.5

# Apply small gaps settings
echo "Setting small gaps..."
swaymsg gaps inner all set 5
swaymsg gaps outer all set 0

# Display current gaps settings
echo "Current gaps settings:"
swaymsg -t get_tree | grep -A 2 "\"gaps\""

echo ""
echo "If gaps still look too large, try:"
echo "1. Run: swaymsg gaps inner all set 1px"
echo "2. Run: swaymsg gaps outer all set 0px"
echo "   (Note the 'px' suffix for physical pixels)"
echo "3. If you're on a HiDPI display, try using 'px' suffix to ensure physical pixels"
echo ""
echo "To test different values without editing your config:"
echo "  swaymsg gaps inner all set <value>"
echo "  swaymsg gaps outer all set <value>"
echo ""
echo "Current windows in workspace:"
swaymsg -t get_tree | grep -B 1 -A 1 "\"name\""
