{ config, pkgs, lib, inputs, ... }: {
  home.packages = with pkgs; [
    eww
    jq
    playerctl
  ];

  home.file = {
    "${config.xdg.configHome}/eww-which-key/eww.yuck".source =
      ./which-key/eww.yuck;
    "${config.xdg.configHome}/eww-which-key/eww.scss".source =
      ./which-key/eww.scss;

    "${config.xdg.configHome}/hypr/scripts/which-key.sh" = {
      source = ./which-key/which-key.sh;
      executable = true;
    };

    "${config.xdg.configHome}/hypr/scripts/exit-current-special.sh" = {
      source = ./scripts/exit-current-special.sh;
      executable = true;
    };

    # toggle gaps helper  (unchanged – keeping your escaped ${})
    "${config.xdg.configHome}/hypr/scripts/toggle-gaps.sh" = {
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        DEFAULT_IN=4
        DEFAULT_OUT="24,8,8,8"

        state_file="\$\{XDG_CACHE_HOME:-$HOME/.cache}/hypr-gaps-state"
        mkdir -p "$(dirname "$state_file")"

        # Try to read the current value from Hyprland
        current="$(
          hyprctl -j getoption general:gaps_in 2>/dev/null \
            | jq -r '.int // .intValue // empty' \
            || true
        )"

        # If that failed, fall back to our own state file
        if [[ -z "$current" ]]; then
          if [[ -f "$state_file" ]]; then
            current="$(<"$state_file")"
          else
            current="$DEFAULT_IN"
          fi
        fi

        if [[ "$current" == "0" ]]; then
          # Turn gaps back ON to your defaults
          hyprctl --batch "keyword general:gaps_in $DEFAULT_IN; keyword general:gaps_out $DEFAULT_OUT"
          echo "$DEFAULT_IN" > "$state_file"
        else
          # Turn gaps OFF
          hyprctl --batch "keyword general:gaps_in 0; keyword general:gaps_out 24,0,0,0"
          echo 0 > "$state_file"
        fi
      '';
      executable = true;
    };

    # ChatGPT floating drawer toggle (UPDATED)
"${config.xdg.configHome}/hypr/scripts/toggle-chatgpt.sh" = {
  text = ''
    #!/usr/bin/env bash
    set -euo pipefail

    CLASS="chrome-chat.openai.com__-Default"
    CHAT_CMD="chatgpt"
    HIDDEN_WS="special:__chatgpt_hidden"

    # First ChatGPT client as compact JSON
    CLIENT=$(hyprctl -j clients \
      | jq -c ".[] | select(.class == \"$CLASS\")" \
      | head -n 1 || true)

    # If no window yet, launch and exit
    if [ -z "$CLIENT" ]; then
      $CHAT_CMD &
      exit 0
    fi

    WIN=$(echo "$CLIENT" | jq -r '.address')
    PINNED=$(echo "$CLIENT" | jq -r '.pinned')
    WS_NAME=$(echo "$CLIENT" | jq -r '.workspace.name')

    # Current workspace id
    CURWS=$(hyprctl -j monitors \
      | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

    # Visible state:
    #   - If pinned => we treat it as "visible"
    #   - If not pinned but not on hidden special ws => also visible
    #   - If on hidden special ws and not pinned => hidden
    VISIBLE=0
    if [ "$PINNED" = "true" ] || [ "$PINNED" = "1" ]; then
      VISIBLE=1
    elif [ "$WS_NAME" != "$HIDDEN_WS" ]; then
      VISIBLE=1
    fi

    if [ "$VISIBLE" -eq 1 ]; then
      # HIDE: unpin, then move to hidden special workspace
      hyprctl dispatch focuswindow "address:$WIN"
      # toggle pin off if currently pinned
      if [ "$PINNED" = "true" ] || [ "$PINNED" = "1" ]; then
        hyprctl dispatch pin
      fi
      hyprctl dispatch movetoworkspacesilent "$HIDDEN_WS,address:$WIN"
    else
      # SHOW: move to current workspace, pin and focus
      hyprctl dispatch movetoworkspacesilent "$CURWS,address:$WIN"
      hyprctl dispatch focuswindow "address:$WIN"
      hyprctl dispatch pin
    fi
  '';
  executable = true;
};
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      plugin {
        hyprhook {
          onSubmap = ${config.xdg.configHome}/hypr/scripts/which-key.sh
        }
      }

      ########################################
      # WINDOW MANAGER MODE
      ########################################
      submap = Window-Manager
      bindd = ,h, Focus window left, movefocus, l
      bindd = ,l, Focus window right, movefocus, r
      bindd = ,k, Focus window up, movefocus, u
      bindd = ,j, Focus window down, movefocus, d
      bindd = SHIFT,h, Move window left, swapwindow, l
      bindd = SHIFT,l, Move window right, swapwindow, r
      bindd = SHIFT,k, Move window up, swapwindow, u
      bindd = SHIFT,j, Move window down, swapwindow, d
      bindd = ALT,h, Resize window shrink horizontal, resizeactive, -60 0
      bindd = ALT,l, Resize window grow horizontal, resizeactive,  60 0
      bindd = ALT,k, Resize window shrink vertical, resizeactive,  0 -60
      bindd = ALT,j, Resize window grow vertical, resizeactive,  0  60
      bindd = ,s, Toggle split, layoutmsg, togglesplit
      bindd = ,p, Toggle pseudotile, pseudo
      bindd = ,t, Toggle floating, togglefloating
      bindd = ,f, Toggle fullscreen, fullscreen, 1
      bindd = ,m, Swap with master, layoutmsg, swapwithmaster master
      bindd = ,n, Add master, layoutmsg, addmaster
      bindd = ,d, Remove master, layoutmsg, removemaster
      bindd = ,r, Cycle layout, layoutmsg, cycle
      bindd = ,escape, Exit Window Manager mode, exec, sh -c 'hyprctl --batch "keyword general:col.active_border rgba(573AC5ee) rgba(280077ee) 45deg; keyword general:col.inactive_border rgba(595959aa)" ; hyprctl dispatch submap reset'
      bindd = ,return, Exit Window Manager mode, exec, sh -c 'hyprctl --batch "keyword general:col.active_border rgba(573AC5ee) rgba(280077ee) 45deg; keyword general:col.inactive_border rgba(595959aa)" ; hyprctl dispatch submap reset'

      ########################################
      # WORKSPACE MODE
      ########################################
      submap = Workspaces
      bindd = ,h, Previous workspace, workspace, e-1
      bindd = ,l, Next workspace, workspace, e+1
      bindd = ,j, Next workspace, workspace, e+1
      bindd = ,k, Previous workspace, workspace, e-1
      bindd = SHIFT,h, Move window to previous workspace, movetoworkspace, e-1
      bindd = SHIFT,l, Move window to next workspace, movetoworkspace, e+1
      bindd = ,1, Switch to workspace 1, workspace, 1
      bindd = ,2, Switch to workspace 2, workspace, 2
      bindd = ,3, Switch to workspace 3, workspace, 3
      bindd = ,4, Switch to workspace 4, workspace, 4
      bindd = ,5, Switch to workspace 5, workspace, 5
      bindd = ,6, Switch to workspace 6, workspace, 6
      bindd = ,7, Switch to workspace 7, workspace, 7
      bindd = ,8, Switch to workspace 8, workspace, 8
      bindd = ,9, Switch to workspace 9, workspace, 9
      bindd = ,0, Switch to workspace 10, workspace, 10
      bindd = SHIFT,1, Move window to workspace 1, movetoworkspace, 1
      bindd = SHIFT,2, Move window to workspace 2, movetoworkspace, 2
      bindd = SHIFT,3, Move window to workspace 3, movetoworkspace, 3
      bindd = SHIFT,4, Move window to workspace 4, movetoworkspace, 4
      bindd = SHIFT,5, Move window to workspace 5, movetoworkspace, 5
      bindd = SHIFT,6, Move window to workspace 6, movetoworkspace, 6
      bindd = SHIFT,7, Move window to workspace 7, movetoworkspace, 7
      bindd = SHIFT,8, Move window to workspace 8, movetoworkspace, 8
      bindd = SHIFT,9, Move window to workspace 9, movetoworkspace, 9
      bindd = SHIFT,0, Move window to workspace 10, movetoworkspace, 10
      bindd = ,escape, Exit Workspace mode, submap, reset
      bindd = ,return, Exit Workspace mode, submap, reset

      ########################################
      # APP LAUNCHER MODE
      ########################################
      submap = Application
      bindd = ,a, Audio Settings, exec, sh -c 'pavucontrol & hyprctl dispatch submap reset'
      bindd = ,r, Remmina (Remote Desktop), exec, sh -c 'remmina & hyprctl dispatch submap reset'
      bindd = ,b, Launch browser Zen, exec, sh -c 'zen & hyprctl dispatch submap reset'
      bindd = ,t, Launch terminal Ghostty, exec, sh -c 'ghostty & hyprctl dispatch submap reset'
      bindd = ,f, Launch file manager Dolphin, exec, sh -c 'dolphin & hyprctl dispatch submap reset'
      bindd = ,o, Launch Obsidian notes, exec, sh -c 'obsidian & hyprctl dispatch submap reset'
      bindd = ,m, Launch Spotify music, exec, sh -c 'spotify & hyprctl dispatch submap reset'
      bindd = ,s, Launch Slack, exec, sh -c 'slack & hyprctl dispatch submap reset'
      bindd = ,d, Launch Discord, exec, sh -c 'discord & hyprctl dispatch submap reset'
      bindd = ,w, Launch Wofi app menu, exec, sh -c 'wofi --show drun & hyprctl dispatch submap reset'
      bindd = ,escape, Exit Application mode, submap, reset
      bindd = ,return, Exit Application mode, submap, reset

      ########################################
      # SYSTEM MODE
      ########################################
      submap = System
      bindd = ,u, Volume up five, exec, pamixer -i 5
      bindd = ,d, Volume down five, exec, pamixer -d 5
      bindd = ,m, Toggle mute, exec, pamixer -t
      bindd = ,b, Brightness down five, exec, brightnessctl set 5%-
      bindd = SHIFT,b, Brightness up five, exec, brightnessctl set +5%
      bindd = ,l, Lock session, exec, hyprlock
      bindd = ,p, Power off system, exec, systemctl poweroff
      bindd = ,escape, Exit System mode, submap, reset
      bindd = ,return, Exit System mode, submap, reset

      ########################################
      # LAYOUT MODE (SUPER+SHIFT+Q)
      ########################################
      submap = Layout
      bindd = ,d, Use dwindle layout, exec, sh -c 'hyprctl keyword general:layout dwindle'
      bindd = ,m, Use master layout, exec, sh -c 'hyprctl keyword general:layout master'
      bindd = ,g, Toggle gaps, exec, ${config.xdg.configHome}/hypr/scripts/toggle-gaps.sh
      bindd = ,b, Toggle blur, exec, sh -c 'CURRENT=$(hyprctl -j getoption decoration:blur:enabled | jq ".int"); if [ "$CURRENT" -eq 1 ]; then hyprctl keyword decoration:blur:enabled 0; else hyprctl keyword decoration:blur:enabled 1; fi'
      bindd = ,a, Toggle animations, exec, sh -c 'CURRENT=$(hyprctl -j getoption animations:enabled | jq ".int"); if [ "$CURRENT" -eq 1 ]; then hyprctl keyword animations:enabled 0; else hyprctl keyword animations:enabled 1; fi'
      bindd = ,r, Cycle layout, layoutmsg, cycle
      bindd = ,escape, Exit Layout mode, submap, reset
      bindd = ,return, Exit Layout mode, submap, reset

      ########################################
      # MEDIA MODE (SUPER+SHIFT+W)
      ########################################
      submap = Media
      bindd = ,space, Play/pause, exec, playerctl play-pause
      bindd = ,n, Next track, exec, playerctl next
      bindd = ,p, Previous track, exec, playerctl previous
      bindd = ,s, Stop playback, exec, playerctl stop
      bindd = ,u, Volume up five, exec, pamixer -i 5
      bindd = ,d, Volume down five, exec, pamixer -d 5
      bindd = ,m, Toggle mute, exec, pamixer -t
      bindd = SHIFT,m, Toggle mic mute, exec, pamixer --default-source -t
      bindd = ,escape, Exit Media mode, submap, reset
      bindd = ,return, Exit Media mode, submap, reset

      ########################################
      # UTILITY MODE (SUPER+SHIFT+E)
      ########################################
      submap = Utility
      bindd = ,s, Take screenshot, exec, sh -c '~/scripts/screenshot.sh; hyprctl dispatch submap reset'
      bindd = ,e, Emoji picker, exec, sh -c 'wofi-emoji; hyprctl dispatch submap reset'
      bindd = ,w, Wallpaper selector, exec, sh -c '~/.config/wofi/wofi-wallpaper-selector.sh; hyprctl dispatch submap reset'
      bindd = ,y, Reload waybar, exec, sh -c 'pkill -SIGUSR2 waybar; hyprctl dispatch submap reset'
      bindd = ,c, Clipboard history, exec, sh -c "cliphist list | wofi --dmenu | cliphist decode | wl-copy; hyprctl dispatch submap reset"
      bindd = ,t, Toggle term scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace term; hyprctl dispatch submap reset'
      bindd = ,escape, Exit Utility mode, submap, reset
      bindd = ,return, Exit Utility mode, submap, reset

      ########################################
      # DEV MODE (SUPER+SHIFT+R)
      ########################################
      submap = Dev
      bindd = ,r, Nvim rb helper, exec, sh -c 'nvim -e sh -c "rb"; hyprctl dispatch submap reset'
      bindd = ,c, Nvim conf helper, exec, sh -c 'nvim -e sh -c "conf"; hyprctl dispatch submap reset'
      bindd = ,l, Tail Hyprland log, exec, sh -c 'ghostty -e sh -lc "journalctl -fu hyprland"; hyprctl dispatch submap reset'
      bindd = ,g, Git TUI, exec, sh -c 'ghostty -e lazygit; hyprctl dispatch submap reset'
      bindd = ,o, Open config dir, exec, sh -c "dolphin ~/.config; hyprctl dispatch submap reset'
      bindd = ,escape, Exit Dev mode, submap, reset
      bindd = ,return, Exit Dev mode, submap, reset

      ########################################
      # DEFAULT BACK TO NORMAL
      ########################################
      submap = reset
    '';

    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [ inputs.hyprhook.packages.${pkgs.stdenv.hostPlatform.system}.hyprhook ];
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
        "GTK_THEME,Tokyonight-Dark"
        "XCURSOR_THEME,Bibata-Modern-Ice"
      ];

      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };

      input = {
        follow_mouse = 1;
        touchpad = { natural_scroll = true; };
        sensitivity = 0;
      };

      general = {
        gaps_in = 4;
        gaps_out = "24,8,8,8";
        border_size = 2;
        "col.active_border" = "rgba(573AC5ee) rgba(280077ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "winOut, 0.10, 0.90, 0.15, 1.00"
          "softIO, 0.25, 0.80, 0.20, 1.00"
          "gatherBounce, 0.1, 0.9, 0.1, 1.1"
        ];
        animation = [
          "windows,     1, 6,  winOut,  popin 80%"
          "windowsOut,  1, 5,  winOut,  popin 80%"
          "border,      1, 8,  softIO"
          "borderangle, 1, 8,  softIO, loop"
          "fade,        1, 5,  softIO"
          "workspaces,  1, 4,  softIO, slide"
          "specialWorkspace, 1, 6, default, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        mfact = 0.55;
        new_on_top = true;
        orientation = "center";
        allow_small_split = true;
      };

      gestures = {
        gesture = [ "3, horizontal, workspace" ];
        workspace_swipe_invert = true;
        workspace_swipe_distance = 200;
        workspace_swipe_forever = true;
      };

      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        disable_hyprland_logo = true;
      };

      layerrule = [
        "match:namespace Which Key, blur on"
        "match:namespace waybar, blur on"
      ];

      windowrule = [
        # Remmina
        "match:class org.remmina.Remmina, match:title ^(Remmina Remote Desktop Client)$, float on, center on"
        "match:class org.remmina.Remmina, suppress_event fullscreen maximize"

        # Screenkey / audio tools
        "match:class screenkey, float on"
        "match:class org.pulseaudio.pavucontrol, float on"
        "match:class ^(com.gabm.satty)$, float on, fullscreen_state 0 0"

        # Skyrim
        "match:title ^(Skyrim Special Edition)$, float on, center on, min_size 3360 1440, border_size 0, rounding 0"

        "match:title ^(File Upload.*)$, match:class zen, float on, center on"

        # Ghostty opacity
        "match:class com.mitchellh.ghostty, opacity 0.9"

        # Spotify / Steam to special workspaces
        "match:class Spotify, workspace special:music"
        "match:class steam, workspace special:steam silent"
        "match:class ^(steam_app_.*)$, workspace special:steam silent"

        # Obsidian notes scratchpad
        "match:class obsidian, float on, center on,  size (monitor_w)*0.9 (monitor_h)*0.9, opacity 0.65, workspace special:notes"

        # TermPad scratchpad
        "match:title ^(TermPad)$, float on, center on,  size (monitor_w)*0.9 (monitor_h)*0.9, opacity 0.65, workspace special:term"

        # Zen scratch browser
        "match:class zen, match:workspace special:zen, float on, center on, size (monitor_w)*0.9 (monitor_h)*0.9, opacity 0.65"

        # ChatGPT floating drawer (nofocus REMOVED)
        "match:class ^chrome-chat\\.openai\\.com__-Default$, float on, size (monitor_w)*0.25 (monitor_h)*0.92, move (monitor_w)*0.01 (monitor_h)*0.04, opacity 0.85"

        # Minecraft - force opaque rendering (prevents transparency on NVIDIA/Wayland)
        "match:title ^(Minecraft.*)$, opacity 1.0 override 1.0 override"

        # Slack / Discord / game routing
        "match:class Slack, workspace special:slack"
        "match:class discord, workspace special:slack"
        "match:title ^(Skyrim Special Edition)$, workspace special:game"
        "match:class ^(worldbox)$, workspace special:game"

        # Gather styling
        "match:initial_title app\\.v2\\.gather\\.town_/app/halon-61af8bed-9d91-4e9f-9f54-eddb8cc02782, workspace special:slack"
        "match:title ^Halon \\\\| Gather$, border_color rgba(88ccffff) rgba(cc88ffff) 45deg rgba(20222aff) rgba(10121aff) 225deg"
        "match:title ^Halon \\\\| Gather$, border_size 4"
        "match:title ^Halon \\\\| Gather$, rounding 18"
        "match:title ^Halon \\\\| Gather$, opacity 1.0 0.85"
        "match:title ^Halon \\\\| Gather$, animation popin 80%"
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
        "special:term, on-created-empty:ghostty --title=TermPad"
        "special:zen, on-created-empty:zen"
      ];

      exec-once = [
        "swww-daemon -f xrgb"
        "nm-applet"
        "waybar"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "[workspace special:music silent] spotify"
        "[workspace special:steam silent] stea"
        "[workspace special:notes silent] obsidian"
        "eww -c ~/.config/eww-which-key daemon"
        "hyprctl plugin load ${
          inputs.hyprhook.packages.${pkgs.stdenv.hostPlatform.system}.hyprhook
        }/lib/libHyprhook.so"
        "chatgpt"
      ];

      bind = [
        "$mainMod, X, exec, ${./scripts/exit-current-special.sh}"
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mainMod, Return, exec, ghostty"
        "$mainMod, slash, exec, ${./wofi-window-switch.sh}"
        "$mainMod SHIFT, X, killactive,"
        "$mainMod CTRL, E, exec, dolphin"
        "$mainMod, P, togglefloating,"
        "$mainMod, P, pin,"
        "ALT, Space, exec, wofi -i --show drun"
        "$mainMod, Tab,  cyclenext"
        "$mainMod, Space,  focuscurrentorlast"
        "$mainMod, H,  movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod SHIFT, H,  swapwindow, l"
        "$mainMod SHIFT, L, swapwindow, r"
        "$mainMod SHIFT, K, swapwindow, u"
        "$mainMod SHIFT, J, swapwindow, d"
        "$mainMod SHIFT CTRL, J,  movecurrentworkspacetomonitor, DP-2"
        "$mainMod SHIFT CTRL, K,  movecurrentworkspacetomonitor, DP-1"

        # Modal home row
        "$mainMod, A, submap, Application"
        "$mainMod, S, submap, System"
        "$mainMod, D, submap, Workspaces"
        "$mainMod, F, exec, sh -c 'hyprctl --batch \"keyword general:col.active_border rgba(fab387ee) rgba(cba6f7ee) 45deg; keyword general:col.inactive_border rgba(45475aaa)\" ; hyprctl dispatch submap Window-Manager'"

        # Top-row utility modes
        "$mainMod SHIFT, Q, submap, Layout"
        "$mainMod SHIFT, W, submap, Media"
        "$mainMod SHIFT, E, submap, Utility"
        "$mainMod SHIFT, R, submap, Dev"

        # Scratchpads (special:)
        "$mainMod, N, togglespecialworkspace,notes"
        "$mainMod CNRL, N, movetoworkspacesilent,special:notes"
        "$mainMod, W, togglespecialworkspace,slack"
        "$mainMod CTRL, W, movetoworkspacesilent,special:slack"
        "$mainMod, E, togglespecialworkspace,music"
        "$mainMod CTRL, E, movetoworkspacesilent,special:music"
        "$mainMod, R, togglespecialworkspace,steam"
        "$mainMod CTRL, R, movetoworkspacesilent,special:steam"
        "$mainMod, T, togglespecialworkspace,term"
        "$mainMod CTRL, T, movetoworkspacesilent,special:term"
        "$mainMod, G, togglespecialworkspace,game"
        "$mainMod CTRL, G, movetoworkspacesilent,special:game"

        # Zen scratch
        "$mainMod, U, togglespecialworkspace,zen"
        "$mainMod CTRL, U, movetoworkspacesilent,special:zen"

        # ChatGPT floating drawer
        "$mainMod, C, exec, ${config.xdg.configHome}/hypr/scripts/toggle-chatgpt.sh"
        "$mainMod CTRL, C, focuswindow, class:^(chrome-chat\\.openai\\.com__-Default)$"

        "$mainMod, Z,  fullscreen, 1"
        "$mainMod SHIFT, Z,  fullscreen"
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
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, F3, exec, brightnessctl -d *::kbd_backlight set +33%"
        "$mainMod, F2, exec, brightnessctl -d *::kbd_backlight set 33%-"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
        ", XF86AudioLowerVolume, exec, pamixer -d 5 "
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -m"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%- "
        ", XF86MonBrightnessUp, exec, brightnessctl set +5% "
        ''$mainMod SHIFT, N, exec, nvim -e sh -c "rb"''
        ''$mainMod SHIFT, C, exec, nvim -e sh -c "conf"''
        ", Print, exec, ~/scripts/screenshot.sh"
        "$mainMod, Y, exec, pkill -SIGUSR2 waybar"
        "$mainMod, O, exec, ~/.config/wofi/wofi-wallpaper-selector.sh"
        "$mainMod SHIFT, J, exec, wofi-emoji"
        "$mainMod Alt Shift, L, exec, hyprlock "
        "$mainMod SHIFT, M, layoutmsg, swapwithmaster master"
        "$mainMod CTRL, M,  layoutmsg, addmaster"
        "$mainMod ALT, M,   layoutmsg, removemaster"
        "$mainMod, M,       layoutmsg, cyclenext"
        "$mainMod SHIFT, A, exec, pavucontrol"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
