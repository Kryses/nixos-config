#!/usr/bin/env bash
set -euo pipefail

# Get the name of the special workspace on the focused monitor
name="$(hyprctl monitors -j 2>/dev/null \
  | jq -r '.[] | select(.focused == true) | .specialWorkspace.name // ""')"

# If there's no special workspace visible, bail out
if [[ -z "$name" || "$name" == "0" || "$name" == "()" ]]; then
  exit 0
fi

# Some setups use "special:<name>" – strip the prefix if present
short="$name"
if [[ "$short" == special:* ]]; then
  short="${short#special:}"
fi

# Toggle off the currently visible special workspace
hyprctl dispatch togglespecialworkspace "$short"

