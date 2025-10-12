#!/usr/bin/env bash
# Toggle to a workspace: if already on target, go to previous; otherwise switch to target.
# Usage: toggle_workspace.sh <workspace-name-or-id>
set -euo pipefail
TARGET="$1"
HYPRCTL="hyprctl"

# State file per-monitor
STATE_DIR="$HOME/.local/state/hypr"
mkdir -p "$STATE_DIR"

# Find current workspace name and previous workspace from hyprctl
CUR_WS_JSON=$($HYPRCTL workspaces -j 2>/dev/null || echo "[]")
if [[ "${CUR_WS_JSON}" == "[]" ]]; then
  echo "No workspaces found"
  exit 1
fi

# get active workspace for the first monitor reported by hyprctl activewindow
ACTIVE_WS=$($HYPRCTL activewindow -j 2>/dev/null | jq -r '.workspace.name // empty')
if [[ -z "$ACTIVE_WS" ]]; then
  # fallback: pick the first workspace with 'focused' true
  ACTIVE_WS=$(echo "$CUR_WS_JSON" | jq -r '.[] | select(.id) | .name' | head -n1)
fi

# Determine monitor of active workspace (we'll store per-monitor last)
MONITOR=$($HYPRCTL monitors -j 2>/dev/null | jq -r '.[] | select(.focused==true) | .name' || echo "")
if [[ -z "$MONITOR" ]]; then
  MONITOR=main
fi

STATE_FILE="$STATE_DIR/lastws_${MONITOR}"
PREV=$(cat "$STATE_FILE" 2>/dev/null || echo "")

# If already on TARGET, and PREV exists, go to PREV
if [[ "$ACTIVE_WS" == "$TARGET" && -n "$PREV" ]]; then
  $HYPRCTL dispatch workspace "$PREV"
  # swap stored values
  echo "$ACTIVE_WS" > "$STATE_FILE"
  exit 0
fi

# Otherwise, switch to TARGET and update PREV
$HYPRCTL dispatch workspace "$TARGET"
# store previous workspace (if different)
if [[ "$ACTIVE_WS" != "$TARGET" ]]; then
  echo "$ACTIVE_WS" > "$STATE_FILE"
fi
exit 0
