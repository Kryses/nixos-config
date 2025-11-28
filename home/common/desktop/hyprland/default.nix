{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      # pkgs.hyprlandPlugins.hyprsplit
      # pkgs.hyprlandPlugins.hyprspace
    ];
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mainMod" = "SUPER";

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XCURSOR_SIZE,36"
        "QT_QPA_PLATFORM,wayland"
        "XDG_SCREENSHOTS_DIR,~/wallpaper"
      ];

      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };

      input = {
        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 3;
        "col.active_border" = "rgba(573AC5ee) rgba(280077ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 16;
          passes = 2;
          new_optimizations = true;
        };

        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        # bezier = "myBezier, 0.33, 0.82, 0.9, -0.08";

        animation = [
          "windows,     1, 7,  myBezier"
          "windowsOut,  1, 7,  default, popin 80%"
          "border,      1, 10, default"
          "borderangle, 1, 8,  default"
          "fade,        1, 7,  default"
          "workspaces,  1, 6,  default"
        ];
      };

      dwindle = {
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        mfact = 0.55;
        new_on_top = true;
        orientation = "center";
        allow_small_split = true;
      };

      gestures = {
        gesture = [
          "3, horizontal, workspace"
        ];
        # workspace_swipe_enable = true;
        # workspace_swipe_fingers = 3;
        workspace_swipe_invert = true;
        workspace_swipe_distance = 200;
        workspace_swipe_forever = true;
      };

      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        # render_ahead_of_time = false;
        disable_hyprland_logo = true;
      };

      windowrulev2 = [
        "tile, class:(Redot)"
        "tile, class:(org.remmina.Remmina)"
        "fullscreenstate 0, class:(org.remmina.Remmina)"
        "suppressevent maximize, class:(org.remmina.Remmina)"
        "float, class:(org.remmina.Remmina), title:(Remmina Remote Desktop Client)"
        "float, class:(screenkey)"
        "float, class:(org.pulseaudio.pavucontrol)"
        "float, class:^(com.gabm.satty)$"
        "fullscreenstate 0, class:(com.gabm.satty)"
        "float, title:^(Skyrim Special Edition)$"
        "norounding, title:^(Skyrim Special Edition)$"
        "noborder, title:^(Skyrim Special Edition)$"
        "float, workspace:special:slack"
        "minsize 3360 1440, title: ^(Skyrim Special Edition)$"
        "center, title: ^(Skyrim Special Edition)$"
        "opacity 0.9, class: (com.mitchellh.ghostty)"
        "workspace special:music, class: (Spotify)"
        "workspace special:steam, class: (steam)"

        "workspace special:notes, class: (obsidian)"
        "float, class: (obsidian)"
        "center, class: (obsidian)"
        "size 2000 1340, class: (obsidian)"
        "opacity 0.65, class: (obsidian)"

        "workspace special:slack, class: (Slack)"
        "workspace special:slack, class: (discord)"
        "workspace special:steam, class: ^(steam_app_.*)$"
        "workspace special:game, title: ^(Skyrim Special Edition)$"
        "workspace special:game, class: ^(worldbox)$"
      ];
      workspace = [
        "1, monitor:DP-1"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-2"
        "7, monitor:DP-2"
        "8, monitor:DP-2"
        "9, monitor:DP-2"
        "10, monitor:DP-2"
        "special:slack, on-created-empty:foot"
        "special:music, on-created-empty:foot"
        "special:steam, on-created-empty:foot"
        "special:notes, on-created-empty:foot"
        "special:game, on-created-empty:foot"
      ];
      exec-once = [
        "swww-daemon -f xrgb"
        "nm-applet"
        "waybar"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "[workspace special:music silent] spotify"
        "[workspace special:steam silent] steam"
        "[workspace special:notes silent] obsidian"
      ];

      bind = [
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        "$mainMod, Return, exec, ghostty"
        "$mainMod, Q, killactive,"
        # "$mainMod, M, exit,"
        "$mainMod CTRL, E, exec, dolphin"
        "$mainMod, F, togglefloating,"
        "$mainMod, P, togglefloating,"
        "$mainMod, P, pin,"
        "ALT, Space, exec, wofi -i --show drun"
        # "$mainMod, P, pseudo, # dwindle"
        "$mainMod, S, togglesplit, # dwindle"

        # Move focus with mainMod + arrow keys
        "ALT, Tab,  cyclenext"
        "$mainMod, Space,  focuscurrentorlast"
        "$mainMod, H,  movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K,    movefocus, u"
        "$mainMod, J,  movefocus, d"

        # Moving windows
        "$mainMod SHIFT, H,  swapwindow, l"
        "$mainMod SHIFT, L, swapwindow, r"
        "$mainMod SHIFT, K,    swapwindow, u"
        "$mainMod SHIFT, J,  swapwindow, d"

        "$mainMod SHIFT CTRL, J,  movecurrentworkspacetomonitor, DP-2"
        "$mainMod SHIFT CTRL, K,  movecurrentworkspacetomonitor, DP-1"

        # Window resizing                     X  Y
        "$mainMod CTRL, H,  resizeactive, -60 0"
        "$mainMod CTRL, L, resizeactive,  60 0"
        "$mainMod CTRL, K,    resizeactive,  0 -60"
        "$mainMod CTRL, J,  resizeactive,  0  60"
        "$mainMod, Z,  fullscreen, 1"
        "$mainMod SHIFT, Z,  fullscreen"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Keyboard backlight
        "$mainMod, F3, exec, brightnessctl -d *::kbd_backlight set +33%"
        "$mainMod, F2, exec, brightnessctl -d *::kbd_backlight set 33%-"

        # Volume and Media Control
        ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
        ", XF86AudioLowerVolume, exec, pamixer -d 5 "
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -m"

        # Brightness control
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%- "
        ", XF86MonBrightnessUp, exec, brightnessctl set +5% "

        # Configuration files
        ''$mainMod SHIFT, N, exec, nvim -e sh -c "rb"''
        ''$mainMod SHIFT, C, exec, nvim -e sh -c "conf"''
        # ''$mainMod SHIFT, H, exec, alacritty -e sh -c "nvim ~/nix/home-manager/modules/wms/hyprland.nix"''
        # ''$mainMod SHIFT, B, exec, alacritty -e sh -c "nvim ~/nix/home-manager/modules/wms/waybar.nix''
        '', Print, exec, ~/scripts/screenshot.sh''

        # Waybar
        "$mainMod, U, exec, zen"
        "$mainMod, Y, exec, pkill -SIGUSR2 waybar"

        "$mainMod, O, exec, ~/.config/wofi/wofi-wallpaper-selector.sh"

        # "$mainMod SHIFT, P, exec, wofi-pass"
        "$mainMod SHIFT, J, exec, wofi-emoji"

        # Disable all effects
        # "$mainMod Shift, G, exec, ~/.config/hypr/gamemode.sh "
        "$mainMod Alt Shift, L, exec, hyprlock "

        "$mainMod SHIFT, SPACE,layoutmsg, swapwithmaster master"
        "$mainMod CTRL, SPACE,layoutmsg, addmaster"
        "$mainMod ALT, SPACE,layoutmsg, removemaster"
        "$mainMod, SPACE,layoutmsg, cyclenext"
        "$mainMod SHIFT, A, exec, pavucontrol"

        "$mainMod SHIFT, R, movetoworkspacesilent,special:notes"
        "$mainMod, R, togglespecialworkspace,notes"
        # "$mainMod, R, exec, /home/kryses/scripts/show_hide.sh"

        "$mainMod SHIFT, T, movetoworkspacesilent,special:slack"
        "$mainMod, T, togglespecialworkspace,slack"

        "$mainMod SHIFT, G, movetoworkspacesilent,special:music"
        "$mainMod, G, togglespecialworkspace,music"

        "$mainMod SHIFT, W, movetoworkspacesilent,special:steam"
        "$mainMod, W, togglespecialworkspace,steam"

        "$mainMod SHIFT, B, movetoworkspacesilent,special:game"
        "$mainMod, B, togglespecialworkspace,game"

        # "$mainMod SHIFT, G, togglegroup"
        # "$mainMod, G, changegroupactive"
        # "$mainMod CTRL, G, moveintogroup"

        "$mainMod, O, exec, hyprctl keyword general:layout dwindle"
        "$mainMod Shift, O, exec, hyprctl keyword general:layout dwindle"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
