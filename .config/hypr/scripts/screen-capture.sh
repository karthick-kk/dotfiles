#!/usr/bin/env sh
# Grim-based screenshot helper used by Hyprland keybindings
set -eu

SCREEN_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREEN_DIR"

timestamp() {
  date +%Y-%m-%d_%H-%M-%S
}

IMG="$SCREEN_DIR/$(timestamp).png"

case "${1:-full}" in
  full)
    # Capture entire compositor framebuffer (all outputs)
    grim "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    ;;
  display)
    # Capture monitor of the active window (fallback to first monitor)
    if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
      mon_id=$(hyprctl activewindow -j 2>/dev/null | jq -r '.monitor // empty')
      mon_name=$(hyprctl monitors -j 2>/dev/null | jq -r ".[] | select(.id==((${mon_id:-0}))) | .name" 2>/dev/null || echo "")
      if [ -n "$mon_name" ]; then
        grim -o "$mon_name" "$IMG" 2>/tmp/grim_err.log || grim "$IMG"
        wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
        exit 0
      fi
    fi
    grim "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    ;;
  focused)
    # Capture the focused window using hyprctl geometry
    if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
      aw_json=$(hyprctl activewindow -j 2>/dev/null || echo "{}")
      atx=$(echo "$aw_json" | jq -r '.at[0] // empty')
      aty=$(echo "$aw_json" | jq -r '.at[1] // empty')
      w=$(echo "$aw_json" | jq -r '.size[0] // empty')
      h=$(echo "$aw_json" | jq -r '.size[1] // empty')
      if [ -n "$atx" ] && [ -n "$aty" ] && [ -n "$w" ] && [ -n "$h" ]; then
        geom="${w}x${h}+${atx}+${aty}"
        grim -g "$geom" "$IMG" 2>/tmp/grim_err.log && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG" && exit 0
      fi
    fi
    # fallback to full if focused geometry unavailable
    grim "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    ;;
  selection)
    # Interactive selection copied to clipboard
    geom=$(slurp 2>/dev/null || echo "")
    if [ -n "$geom" ]; then
      grim -g "$geom" "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    else
      notify-send "Selection cancelled" "No area selected"
    fi
    ;;
  swappy)
    # Interactive selection and open swappy for editing
    geom=$(slurp 2>/dev/null || echo "")
    if [ -n "$geom" ]; then
      grim -g "$geom" "$IMG" && swappy -f "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    else
      notify-send "Selection cancelled" "No area selected"
    fi
    ;;
  *)
    # Default: open selection GUI via slurp/flameshot bridging (if needed)
    geom=$(slurp 2>/dev/null || echo "")
    if [ -n "$geom" ]; then
      grim -g "$geom" "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    else
      grim "$IMG" && wl-copy <"$IMG" && notify-send "Screenshot saved" "$IMG"
    fi
    ;;
esac
