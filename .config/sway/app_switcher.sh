#!/bin/bash

# List all open applications with their workspace and container ID
apps=$(swaymsg -t get_tree | jq -r '
    .. | select(.type? == "con" and .app_id? != null) |
    "\(.app_id) - \(.name) [Workspace: \(.workspace.name)] \(.id)"
')

# Use wofi or rofi to display the list and get the selected application
selected=$(echo "$apps" | wofi --show dmenu --prompt "Switch to:")

# Extract the container ID from the selected application
container_id=$(echo "$selected" | grep -oE '[0-9]+$')

# Focus the selected application
if [ -n "$container_id" ]; then
    swaymsg "[con_id=$container_id]" focus
fi
