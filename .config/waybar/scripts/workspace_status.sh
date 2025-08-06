#!/bin/bash

# This script outputs the status of Hyprland workspaces for Waybar

# Get the workspace status from Hyprland
workspace_status=$(hyprctl workspaces -j)

# Get the active window's workspace
active_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id')


# Parse the JSON and output icons for Waybar
output=""
for i in {1..10}; do
  if [[ "$i" == "$active_workspace" ]]; then
    # Workspace is active
    output+=" "
  elif echo "$workspace_status" | jq -e ".[] | select(.id == $i and .windows > 0)" > /dev/null; then
    # Workspace is occupied
    output+=" "
  else
    # Workspace is empty
    output+=" "
  fi
  # Add spacing between icons
  output+="  "
done

# Print the output for Waybar
echo "$output"
