#!/bin/bash

# Get the list of all container IDs in all workspaces
containers=$(swaymsg -t get_tree | jq -r '.. | select(.type? == "con" and .app_id? != null) | .id')

# Get the currently focused container ID
focused=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .id')

# Find the next container in the list
found=false
for container in $containers; do
    if $found; then
        swaymsg "[con_id=$container]" focus
        exit 0
    fi
    if [ "$container" == "$focused" ]; then
        found=true
    fi
done

# If no next container is found, focus the first container
first_container=$(echo "$containers" | head -n 1)
swaymsg "[con_id=$first_container]" focus
