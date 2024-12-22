{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
$hypr = ~/.config/hypr

# GENERAL
general {
  no_fade_in = true
  grace = 1
  disable_loading_bar = false
  hide_cursor = true
  ignore_empty_input = true
  text_trim = true
}

#BACKGROUND
background {
    monitor = 
    path = /home/kryses/wallpaper/51203633354_679ed58baf_o.png
    blur_passes = 3
    contrast = 0.8916
    brightness = 0.7172
    vibrancy = 0.1696
    vibrancy_darkness = 0
}

# TIME HR
label {
    monitor =
    text = cmd[update:1000] echo -e "$(date +"%I")"
    color = rgba(255, 255, 255, 1)
    shadow_pass = 2
    shadow_size = 3
    shadow_color = rgb(0,0,0)
    shadow_boost = 1.2
    font_size = 150
    font_family = JetBrains Mono Nerd Font Mono Bold
    position = 0, -250
    halign = center
    valign = top
}

# TIME 
label {
    monitor =
    text = cmd[update:1000] echo -e "$(date +"%M")"
    color = rgba(255, 255, 255, 1)
    font_size = 150
    font_family = JetBrains Mono Nerd Font Mono Bold
    position = 0, -420
    halign = center
    valign = top
}

# DATE
label {
    monitor =
    text = cmd[update:1000] echo -e "$(date +"%e %B, %A %Y")"
    color = rgba(255, 255, 255, 1)
    font_size = 17
    font_family = JetBrains Mono Nerd Font Mono
    position = 0, -130
    halign = center
    valign = center
}

# INPUT
input-field {
    monitor =
    size = 250, 60
    outline_thickness = 0
    outer_color = rgba(0, 0, 0, 0)
    dots_size = 0.1
    dots_spacing = 1 
    dots_center = true
    inner_color = rgba(0, 0, 0, 0)
    font_color = rgba(200, 200, 200, 1)
    fade_on_empty = false
    font_family = JetBrains Mono Nerd Font Mono
    placeholder_text = <span> $USER</span>
    hide_input = false
    position = 0, -470
    halign = center
    valign = center
    zindex = 10
}

# Uptime
label {
    monitor =
    text = cmd[update:60000] echo "<b> "$(uptime -p)" </b>"
    color = $color12
    font_size = 14
    font_family = Inter Display Medium
    position = 0, -0.005
    halign = center
    valign = bottom
}
    '';
  }; 
}