#!/usr/bin/env python3
"""move_and_follow.sh (Python)
Usage: move_and_follow.sh <workspace_number>

Moves the currently focused window to the target workspace and then
switches focus to that workspace, ensuring Hyprland's "previous"
workspace history points to the workspace you came from.
"""

import json
import shutil
import subprocess
import sys
import time


def log(msg: str) -> None:
    return


def err(msg: str, code: int = 1) -> None:
    print(msg, file=sys.stderr)
    log(f"ERROR: {msg}")
    sys.exit(code)


if len(sys.argv) != 2:
    err(f"Usage: {sys.argv[0]} <workspace_number>", 2)

target = sys.argv[1]
log(f"START target={target}")

hyprctl = shutil.which("hyprctl")
if not hyprctl:
    err("hyprctl not found in PATH", 127)


def get_active_workspace() -> str | None:
    try:
        p = subprocess.run([hyprctl, "activeworkspace"], capture_output=True, text=True, check=True)
        # Output is like "workspace ID 1 (1) on monitor HDMI-A-2:"
        line = p.stdout.strip().split()
        if len(line) >= 3 and line[0] == "workspace" and line[1] == "ID":
            return line[2]
    except Exception as e:
        log(f"ERROR get_active_workspace: {e}")
        return None


def dispatch(*args: str) -> subprocess.CompletedProcess:
    try:
        return subprocess.run([hyprctl, "dispatch", *args], capture_output=True, text=True)
    except Exception as e:
        # make a dummy result-like object
        class R:
            returncode = 1
            stdout = ""
            stderr = str(e)

        return R()


# capture current active workspace
cur = get_active_workspace()
log(f"cur={cur}")

# record workspace JSON for debugging
try:
    p_all = subprocess.run([hyprctl, "-j", "workspaces"], capture_output=True, text=True)
    log(f"workspaces_json={p_all.stdout.strip()}")
except Exception as e:
    log(f"failed to read workspaces json: {e}")

# Move the focused window to target
res = dispatch("movetoworkspace", target)
log(f"movetoworkspace rc={res.returncode} out={getattr(res, 'stdout', '').strip()} err={getattr(res, 'stderr', '').strip()}")
if res.returncode != 0:
    log(f"movetoworkspace failed (exiting): {getattr(res, 'stderr', '').strip()}")
    err(f"movetoworkspace failed: {getattr(res, 'stderr', '').strip()}")

# small delay for compositor state to update
time.sleep(0.03)

# Switch back to original workspace briefly to set history
if cur:
    r1 = dispatch("workspace", cur)
    log(f"dispatch workspace cur rc={r1.returncode} out={getattr(r1, 'stdout', '').strip()} err={getattr(r1, 'stderr', '').strip()}")
    time.sleep(0.08)

# Final switch to target so that 'previous' becomes cur
res2 = dispatch("workspace", target)
log(f"dispatch workspace target rc={res2.returncode} out={getattr(res2, 'stdout', '').strip()} err={getattr(res2, 'stderr', '').strip()}")
if res2.returncode != 0:
    log(f"workspace switch to target failed: {getattr(res2, 'stderr', '').strip()}")
    err(f"workspace switch to target failed: {getattr(res2, 'stderr', '').strip()}")

log("DONE")
sys.exit(0)
