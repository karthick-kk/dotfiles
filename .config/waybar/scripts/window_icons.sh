#!/usr/bin/env bash
# Show running application icons for the active workspace (Hyprland) as a JSON array for Waybar
# - Requires: hyprctl, jq
# - Outputs a JSON array of objects: [{"text":"ICON","class":"...","title":"...","address":"..."}, ...]

set -euo pipefail

# Gather clients and monitors
clients_json=$(hyprctl -j clients 2>/dev/null || echo "[]")
active_ws=$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | .activeWorkspace.id' 2>/dev/null | head -n1 || true)

# Build JSON with jq (case-insensitive pattern matching for common apps)
if [ -z "${clients_json// /}" ] || [ "$clients_json" = "[]" ]; then
  echo '[]'
  exit 0
fi

jq -c --arg active_ws "$active_ws" '
  [ .[]
    | select(.mapped != false)
    | select( ("" == $active_ws) or ((.workspace|tostring) == $active_ws) )
    | . as $c
    | {
        text: (
          if (($c.class // $c.appId // $c.title) | test("firefox"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("chromium|chrome"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("code|vscode|code-oss"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("alacritty|foot|kitty|wezterm|gnome-terminal|terminator|foot"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("spotify"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("discord|slack"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("nautilus|thunar|nemo|dolphin"; "i")) then ""
          elif (($c.class // $c.appId // $c.title) | test("vlc|mpv"; "i")) then ""
          else "" end
        ),
        class: ($c.class // ""),
        title: ($c.title // ""),
        address: ($c.address // "")
      }
  ]' <<< "$clients_json" || echo '[]'
