#!/usr/bin/env bash

clients="$(hyprctl clients -j)"
[ -z "$clients" ] && exit 0

selection="$(
  echo "$clients" \
  | jq -r '.[] | "\(.address)  [\(.workspace.name)] \(.class) — \(.title)"' \
  | wofi --dmenu --prompt "Windows"
)"

addr="$(echo "$selection" | awk '{print $1}')"
[ -n "$addr" ] && hyprctl dispatch focuswindow "address:$addr"

