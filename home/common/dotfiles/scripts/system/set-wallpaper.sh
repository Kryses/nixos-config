#!/usr/bin/zsh
wallpaper=$(find ~/photos/wallpapers/3440x1440 -type f | shuf -n 1)    
wal -i "$wallpaper"
xwallpaper --stretch $wallpaper
export QTILE_RELOAD_COLORS_ONLY=true
qtile cmd-obj -o cmd -f reload_config
