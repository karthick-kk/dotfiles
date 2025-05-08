#!/bin/bash

# Script to restart Sway while preserving window positions

# Save the current workspace and window layout information
echo "Saving current window layout..."
LAYOUT_FILE="/tmp/sway_layout_$(date +%s).json"
swaymsg -t get_tree > "$LAYOUT_FILE"

# Parse and extract window positions and workspaces
echo "Extracting window positions..."
WINDOWS_INFO=$(grep -A 10 "\"app_id\|\"class\"" "$LAYOUT_FILE" | grep -B 10 "\"rect\"" | grep -e "\"app_id\"\|\"class\"\|\"id\"\|\"name\"\|\"workspace\"" | sed 's/,$//')

# Reload Sway configuration
echo "Reloading Sway configuration..."
swaymsg reload

# Wait for configuration to reload
sleep 1

# Apply small gaps settings
echo "Setting small gaps..."
swaymsg gaps inner all set 5
swaymsg gaps outer all set 0

# Restore window positions based on saved information
echo "Restoring window positions..."
while read -r line; do
    if [[ $line == *"\"id\""* ]]; then
        WINDOW_ID=$(echo "$line" | sed 's/.*: \([0-9]*\).*/\1/')
    elif [[ $line == *"\"workspace\""* && $WINDOW_ID != "" ]]; then
        WORKSPACE=$(echo "$line" | sed 's/.*: "\([^"]*\)".*/\1/')
        # Move window to its previous workspace
        swaymsg "[con_id=$WINDOW_ID]" move container to workspace "$WORKSPACE"
        WINDOW_ID=""
    fi
done < <(echo "$WINDOWS_INFO")

# Display current gaps settings
echo "Current gaps settings:"
swaymsg -t get_tree | grep -A 2 "\"gaps\""

echo ""
echo "Window positions have been restored!"
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
