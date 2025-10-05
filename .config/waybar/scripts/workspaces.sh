#!/bin/bash
# Unified workspace indicator script for Waybar
# Outputs all workspace icons in a single call (faster than per-workspace scripts)
# Handles click events to switch workspaces

# Handle click events
if [ -n "$WAYBAR_CLICK_X" ]; then
  click_x=$WAYBAR_CLICK_X
  # Each workspace icon is approximately 25 pixels wide (icon + padding)
  workspace_width=25
  workspace=$(( (click_x / workspace_width) + 1 ))
  
  # Clamp to valid range
  if [ "$workspace" -lt 1 ]; then
    workspace=1
  elif [ "$workspace" -gt 10 ]; then
    workspace=10
  fi
  
  # Switch to the clicked workspace
  hyprctl dispatch workspace "$workspace"
  exit 0
fi

# Icons - from original workspace_status.sh (using Unicode code points)
ICON_ACTIVE=$(printf '\uf192')     # Active workspace
ICON_OCCUPIED=$(printf '\uf111')   # Occupied workspace (has windows)
ICON_EMPTY=$(printf '\uf10c')      # Empty workspace

# Read Hyprland state once
ws_json=$(hyprctl -j workspaces 2>/dev/null || echo "[]")
mon_active_id=$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | .activeWorkspace.id' 2>/dev/null || echo "")

# Build output for workspaces 1-10
output=""
for i in {1..10}; do
  ws_entry=$(echo "$ws_json" | jq -r ".[] | select((.id|tostring) == \"$i\") | @json" 2>/dev/null || echo "")
  
  icon="$ICON_EMPTY"
  
  # Check if this workspace is the active one (from monitor)
  if [ "$mon_active_id" = "$i" ]; then
    icon="$ICON_ACTIVE"
  elif [ -n "$ws_entry" ]; then
    windows=$(echo "$ws_entry" | jq -r '.windows // 0')
    if [ "$windows" -gt 0 ]; then
      icon="$ICON_OCCUPIED"
    fi
  fi
  
  # Wrap in clickable button (JSON format for Waybar custom module)
  # Using Pango markup for clickable areas
  output="${output}<span font='14'>${icon}</span>  "
done

# Output with trailing space trimmed
echo -n "${output% }"
