#!/bin/sh
# Wrapper to start Waybar from Hyprland with logs captured
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
# Inherit WAYLAND_DISPLAY from Hyprland's environment
if [ -z "$WAYLAND_DISPLAY" ]; then
    export WAYLAND_DISPLAY="wayland-1"
fi
# Force GDK to use Wayland backend
export GDK_BACKEND=wayland
exec /usr/bin/waybar > /tmp/waybar_hypr.log 2>&1
