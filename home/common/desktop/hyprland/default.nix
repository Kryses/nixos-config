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
     # NEW: toggle gaps helper
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
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      plugin {
        hyprhook {
          onSubmap = ${config.xdg.configHome}/hypr/scripts/which-key.sh
        }
      }

      ########################################
      # WINDOW MANAGER MODE: focus, move, resize, layout
      ########################################
      # Entered via: SUPER + F
      # Inside:
      #   h/j/k/l       -> move focus
      #   Shift+h/j/k/l -> move windows
      #   Alt+h/j/k/l   -> resize
      #   s             -> toggle split
      #   p             -> pseudotile
      #   f             -> fullscreen
      #   m             -> swap with master
      #   n             -> add master
      #   d             -> remove master
      #   r             -> cycle layout
      #   Esc/Enter     -> exit (also resets border colors)

      submap = Window-Manager

      # Focus
      bindd = ,h, Focus window left, movefocus, l
      bindd = ,l, Focus window right, movefocus, r
      bindd = ,k, Focus window up, movefocus, u
      bindd = ,j, Focus window down, movefocus, d

      # Move windows
      bindd = SHIFT,h, Move window left, swapwindow, l
      bindd = SHIFT,l, Move window right, swapwindow, r
      bindd = SHIFT,k, Move window up, swapwindow, u
      bindd = SHIFT,j, Move window down, swapwindow, d

      # Resize windows
      bindd = ALT,h, Resize window shrink horizontal, resizeactive, -60 0
      bindd = ALT,l, Resize window grow horizontal, resizeactive,  60 0
      bindd = ALT,k, Resize window shrink vertical, resizeactive,  0 -60
      bindd = ALT,j, Resize window grow vertical, resizeactive,  0  60

      # Layout controls
      bindd = ,s, Toggle split, togglesplit
      bindd = ,p, Toggle pseudotile, pseudo
      bindd = ,f, Toggle fullscreen, fullscreen, 1
      bindd = ,m, Swap with master, layoutmsg, swapwithmaster master
      bindd = ,n, Add master, layoutmsg, addmaster
      bindd = ,d, Remove master, layoutmsg, removemaster
      bindd = ,r, Cycle layout, layoutmsg, cycle

      # Exit WM mode (Esc)
      bindd = ,escape, Exit Window Manager mode, exec, sh -c 'hyprctl --batch "keyword general:col.active_border rgba(573AC5ee) rgba(280077ee) 45deg; keyword general:col.inactive_border rgba(595959aa)" ; hyprctl dispatch submap reset'

      # Exit WM mode (Enter)
      bindd = ,return, Exit Window Manager mode, exec, sh -c 'hyprctl --batch "keyword general:col.active_border rgba(573AC5ee) rgba(280077ee) 45deg; keyword general:col.inactive_border rgba(595959aa)" ; hyprctl dispatch submap reset'


      ########################################
      # WORKSPACE MODE
      ########################################
      # Entered via: SUPER + D
      # Inside:
      #   h/j/k/l       -> prev/next workspace
      #   Shift+h/j/k/l -> move window to prev/next
      #   1–0           -> jump to workspace
      #   Shift+1–0     -> move window to workspace
      #   Esc/Enter     -> exit

      submap = Workspaces

      # Previous / next workspace
      bindd = ,h, Previous workspace, workspace, e-1
      bindd = ,l, Next workspace, workspace, e+1
      bindd = ,j, Next workspace, workspace, e+1
      bindd = ,k, Previous workspace, workspace, e-1

      # Move current window to prev/next
      bindd = SHIFT,h, Move window to previous workspace, movetoworkspace, e-1
      bindd = SHIFT,l, Move window to next workspace, movetoworkspace, e+1

      # Direct numeric workspace jump
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

      # Move active window to workspace N
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

      # Exit workspace mode
      bindd = ,escape, Exit Workspace mode, submap, reset
      bindd = ,return, Exit Workspace mode, submap, reset


      ########################################
      # APP LAUNCHER MODE (auto exit)
      ########################################
      # Entered via: SUPER + A
      # Inside:
      #   a -> pavucontrol
      #   r -> remmina
      #   b -> browser (Zen)
      #   t -> terminal (Ghostty)
      #   f -> file manager (Dolphin)
      #   o -> Obsidian
      #   m -> Spotify
      #   s -> Slack
      #   d -> Discord
      #   w -> Wofi app launcher
      # Each auto-exits back to normal
      # Esc/Enter as backup exit

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

      # backup exits
      bindd = ,escape, Exit Application mode, submap, reset
      bindd = ,return, Exit Application mode, submap, reset


      ########################################
      # SYSTEM MODE
      ########################################
      # Entered via: SUPER + S
      # Inside:
      #   u -> volume up
      #   d -> volume down
      #   m -> mute
      #   b -> brightness down
      #   B -> brightness up (Shift+b)
      #   l -> lock
      #   p -> poweroff
      #   Esc/Enter -> exit

      submap = System

      bindd = ,u, Volume up five, exec, pamixer -i 5
      bindd = ,d, Volume down five, exec, pamixer -d 5
      bindd = ,m, Toggle mute, exec, pamixer -t

      bindd = ,b, Brightness down five, exec, brightnessctl set 5%-
      bindd = SHIFT,b, Brightness up five, exec, brightnessctl set +5%

      bindd = ,l, Lock session, exec, hyprlock

      # adjust this to your actual power menu if you have one
      bindd = ,p, Power off system, exec, systemctl poweroff

      bindd = ,escape, Exit System mode, submap, reset
      bindd = ,return, Exit System mode, submap, reset


      ########################################
      # SCRATCHPAD MODE
      ########################################
      # Entered via: SUPER + G
      # Inside:
      #   n -> toggle notes    (special:notes)
      #   s -> toggle slack    (special:slack)
      #   m -> toggle music    (special:music)
      #   e -> toggle steam    (special:steam)
      #   g -> toggle game     (special:game)
      #   t -> toggle term     (special:term)
      #
      #   Shift+key moves the active window INTO that special workspace:
      #   Shift+n/s/m/e/g/t
      #
      #   Esc/Enter -> exit back to normal

      submap = Scratchpad

      # Toggle special workspaces + exit mode
      bindd = ,n, Toggle notes scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace notes; hyprctl dispatch submap reset'
      bindd = ,s, Toggle slack scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace slack; hyprctl dispatch submap reset'
      bindd = ,m, Toggle music scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace music; hyprctl dispatch submap reset'
      bindd = ,e, Toggle steam scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace steam; hyprctl dispatch submap reset'
      bindd = ,g, Toggle game scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace game; hyprctl dispatch submap reset'
      bindd = ,t, Toggle term scratchpad, exec, sh -c 'hyprctl dispatch togglespecialworkspace term; hyprctl dispatch submap reset'

      # Move active window to special workspace (silent) + exit mode
      bindd = SHIFT,n, Send window to notes scratchpad, exec, sh -c 'hyprctl dispatch movetoworkspacesilent special:notes; hyprctl dispatch submap reset'
      bindd = SHIFT,s, Send window to slack scratchpad, exec, sh -c 'hyprctl dispatch movetoworkspacesilent special:slack; hyprctl dispatch submap reset'
      bindd = SHIFT,m, Send window to music scratchpad, exec, sh -c 'hyprctl dispatch movetoworkspacesilent special:music; hyprctl dispatch submap reset'
      bindd = SHIFT,e, Send window to steam scratchpad, exec, sh -c 'hyprctl dispatch movetoworkspacesilent special:steam; hyprctl dispatch submap reset'
      bindd = SHIFT,g, Send window to game scratchpad, exec, sh -c 'hyprctl dispatch movetoworkspacesilent special:game; hyprctl dispatch submap reset'
      bindd = SHIFT,t, Send window to term scratchpad, exec, sh -c 'hyprctl dispatch movetoworkspacesilent special:term; hyprctl dispatch submap reset'

      bindd = ,escape, Exit Scratchpad mode, submap, reset
      bindd = ,return, Exit Scratchpad mode, submap, reset


      ########################################
      # LAYOUT MODE (Q)
      ########################################
      # Enter: SUPER + Q
      # Inside:
      #   d -> dwindle layout
      #   m -> master layout
      #   g -> toggle gaps
      #   b -> toggle blur
      #   a -> toggle animations
      #   r -> cycle layout
      #   Esc/Enter -> exit

      submap = Layout

      # Switch to dwindle layout
      bindd = ,d, Use dwindle layout, exec, sh -c 'hyprctl keyword general:layout dwindle'

      # Switch to master layout
      bindd = ,m, Use master layout, exec, sh -c 'hyprctl keyword general:layout master'

      # Toggle gaps: 0 vs configured
      bindd = ,g, Toggle gaps, exec, ${config.xdg.configHome}/hypr/scripts/toggle-gaps.sh

      # Toggle blur
      bindd = ,b, Toggle blur, exec, sh -c 'CURRENT=$(hyprctl -j getoption decoration:blur:enabled | jq ".int"); if [ "$CURRENT" -eq 1 ]; then hyprctl keyword decoration:blur:enabled 0; else hyprctl keyword decoration:blur:enabled 1; fi'

      # Toggle animations
      bindd = ,a, Toggle animations, exec, sh -c 'CURRENT=$(hyprctl -j getoption animations:enabled | jq ".int"); if [ "$CURRENT" -eq 1 ]; then hyprctl keyword animations:enabled 0; else hyprctl keyword animations:enabled 1; fi'

      # Reuse layout cycle msg
      bindd = ,r, Cycle layout, layoutmsg, cycle

      bindd = ,escape, Exit Layout mode, submap, reset
      bindd = ,return, Exit Layout mode, submap, reset


      ########################################
      # MEDIA MODE (W)
      ########################################
      # Enter: SUPER + W
      # Inside:
      #   space -> play/pause
      #   n     -> next track
      #   p     -> previous track
      #   s     -> stop
      #   u     -> volume up
      #   d     -> volume down
      #   m     -> mute
      #   M     -> mic mute (Shift+m)
      #   Esc/Enter -> exit

      submap = Media

      # Playback controls (playerctl)
      bindd = ,space, Play/pause, exec, playerctl play-pause
      bindd = ,n, Next track, exec, playerctl next
      bindd = ,p, Previous track, exec, playerctl previous
      bindd = ,s, Stop playback, exec, playerctl stop

      # Volume (pamixer)
      bindd = ,u, Volume up five, exec, pamixer -i 5
      bindd = ,d, Volume down five, exec, pamixer -d 5
      bindd = ,m, Toggle mute, exec, pamixer -t
      bindd = SHIFT,m, Toggle mic mute, exec, pamixer --default-source -t

      bindd = ,escape, Exit Media mode, submap, reset
      bindd = ,return, Exit Media mode, submap, reset


      ########################################
      # UTILITY MODE (E)
      ########################################
      # Enter: SUPER + E
      # Inside:
      #   s -> screenshot
      #   e -> emoji picker
      #   w -> wallpaper selector
      #   y -> reload waybar
      #   c -> clipboard history
      #   t -> toggle term scratchpad
      #   Esc/Enter -> exit

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
      # DEV MODE (R)
      ########################################
      # Enter: SUPER + R
      # Inside:
      #   r -> nvim "rb" helper
      #   c -> nvim "conf" helper
      #   l -> tail hyprland logs in Ghostty
      #   g -> Git TUI (lazygit or similar)
      #   o -> open ~/.config in Dolphin
      #   Esc/Enter -> exit

      submap = Dev

      bindd = ,r, Nvim rb helper, exec, sh -c 'nvim -e sh -c "rb"; hyprctl dispatch submap reset'
      bindd = ,c, Nvim conf helper, exec, sh -c 'nvim -e sh -c "conf"; hyprctl dispatch submap reset'
      bindd = ,l, Tail Hyprland log, exec, sh -c 'ghostty -e sh -lc "journalctl -fu hyprland"; hyprctl dispatch submap reset'
      bindd = ,g, Git TUI, exec, sh -c 'ghostty -e lazygit; hyprctl dispatch submap reset'
      bindd = ,o, Open config dir, exec, sh -c "dolphin ~/.config; hyprctl dispatch submap reset"

      bindd = ,escape, Exit Dev mode, submap, reset
      bindd = ,return, Exit Dev mode, submap, reset


      ########################################
      # DEFAULT BACK TO NORMAL
      ########################################
      submap = reset
    '';

    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [ inputs.hyprhook.packages.${pkgs.system}.hyprhook ];
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

      layerrule = [ "match:namespace Which Key, blur on" ];

      windowrule = [
        # --- Remmina -------------------------------------------------
        # Main Remmina window: float the "Remote Desktop Client" dialog
        "match:class org.remmina.Remmina, match:title ^(Remmina Remote Desktop Client)$, float on, center on"

        # Prevent Remmina from trying to fullscreen / maximize itself
        "match:class org.remmina.Remmina, suppress_event fullscreen maximize"

        # --- Screenkey / audio tools --------------------------------
        "match:class screenkey, float on"
        "match:class org.pulseaudio.pavucontrol, float on"
        "match:class ^(com.gabm.satty)$, float on, fullscreen_state 0 0"

        # --- Skyrim window tweaks -----------------------------------
        "match:title ^(Skyrim Special Edition)$, float on, center on, min_size 3360 1440, border_size 0, rounding 0"

        # --- Ghostty: global opacity --------------------------------
        "match:class com.mitchellh.ghostty, opacity 0.9"

        # --- Spotify / Steam to special workspaces ------------------
        "match:class Spotify, workspace special:music"
        "match:class steam, workspace special:steam silent"
        "match:class ^(steam_app_.*)$, workspace special:steam silent"

        # --- Obsidian notes scratchpad ------------------------------
        "match:class obsidian, float on, center on,  size (monitor_w)*0.9 (monitor_h)*0.9, opacity 0.65, workspace special:notes"

        # --- TermPad scratchpad -------------------------------------
        "match:title ^(TermPad)$, float on, center on,  size (monitor_w)*0.9 (monitor_h)*0.9, opacity 0.65, workspace special:term"

        # --- Slack / Discord / game workspace routing ---------------
        "match:class Slack, workspace special:slack"
        "match:class discord, workspace special:slack"
        "match:title ^(Skyrim Special Edition)$, workspace special:game"
        "match:class ^(worldbox)$, workspace special:game"

        # Gather app into slack special workspace
        "match:initial_title app\\.v2\\.gather\\.town_/app/halon-61af8bed-9d91-4e9f-9f54-eddb8cc02782, workspace special:slack"

        # Styling rules (runtime title)
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
          inputs.hyprhook.packages.${pkgs.system}.hyprhook
        }/lib/libHyprhook.so"
      ];

      bind = [
        "$mainMod, X, exec, ${./scripts/exit-current-special.sh}"
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mainMod, Return, exec, ghostty"
        "$mainMod, slash, exec, ${./wofi-window-switch.sh}"
        "$mainMod Shift, Q, killactive,"
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

        # Modal home row: ASDFG
        "$mainMod, A, submap, Application"
        "$mainMod, S, submap, System"
        "$mainMod, D, submap, Workspaces"
        "$mainMod, F, exec, sh -c 'hyprctl --batch \"keyword general:col.active_border rgba(fab387ee) rgba(cba6f7ee) 45deg; keyword general:col.inactive_border rgba(45475aaa)\" ; hyprctl dispatch submap Window-Manager'"
        "$mainMod, G, submap, Scratchpad"

        # Outer ring modes: QWER
        "$mainMod, Q, submap, Layout"
        "$mainMod, W, submap, Media"
        "$mainMod, E, submap, Utility"
        "$mainMod, R, submap, Dev"

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
        "$mainMod, U, exec, zen"
        "$mainMod, Y, exec, pkill -SIGUSR2 waybar"
        "$mainMod, O, exec, ~/.config/wofi/wofi-wallpaper-selector.sh"
        "$mainMod SHIFT, J, exec, wofi-emoji"
        "$mainMod Alt Shift, L, exec, hyprlock "
        "$mainMod SHIFT, M, layoutmsg, swapwithmaster master"
        "$mainMod CTRL, M,  layoutmsg, addmaster"
        "$mainMod ALT, M,   layoutmsg, removemaster"
        "$mainMod, M,       layoutmsg, cyclenext"
        "$mainMod SHIFT, A, exec, pavucontrol"
        "$mainMod SHIFT, T, movetoworkspacesilent,special:slack"
        "$mainMod, T, togglespecialworkspace,slack"
        "$mainMod SHIFT, B, movetoworkspacesilent,special:game"
        "$mainMod, B, togglespecialworkspace,game"
        "$mainMod, grave, togglespecialworkspace,term"
        "$mainMod SHIFT, grave, movetoworkspacesilent,special:term"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}

