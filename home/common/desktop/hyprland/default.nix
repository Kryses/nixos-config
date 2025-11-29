{ config, pkgs, lib, inputs, ... }: {
  home.packages = with pkgs; [ eww jq ];
  home.file = {
    "${config.xdg.configHome}/eww-which-key/eww.yuck".source =
      ./which-key/eww.yuck;
    "${config.xdg.configHome}/eww-which-key/eww.scss".source =
      ./which-key/eww.scss;
    "${config.xdg.configHome}/hypr/scripts/which-key.sh" = {
      source = ./which-key/which-key.sh;
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
            # MASTER MODE: central modal dispatcher
            ########################################
            # Enter with: SUPER + Space (see main bind list)
            # Keys (left-hand only):
            #   a -> Application mode
            #   s -> System mode
            #   d -> Workspace mode
            #   f -> Window-Manager (WM) mode
            #   Esc/Enter -> cancel

            submap = Master

            bindd = ,a, Enter Application mode, submap, Application
            bindd = ,s, Enter System mode, submap, System
            bindd = ,d, Enter Workspace mode, submap, Workspaces
            bindd = ,f, Enter Window Manager mode, submap, Window-Manager
            bindd = ,g, Enter Scratchpad mode, submap, Scratchpad

            bindd = ,escape, Exit Master mode, submap, reset
            bindd = ,return, Exit Master mode, submap, reset

            ########################################
            # WM MODE: focus, move, resize, layout
            ########################################
            # Entered via Master: f
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
            #   Esc/Enter     -> exit

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

            # Exit WM mode
            bindd = ,escape, Exit Window Manager mode, submap, reset
            bindd = ,return, Exit Window Manager mode, submap, reset


            ########################################
            # WORKSPACE MODE
            ########################################
            # Entered via Master: d
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
            # Entered via Master: a
            # Inside:
            #   b -> browser (zen in your case)
            #   t -> terminal
            #   f -> file manager
            #   o -> obsidian
            #   m -> spotify/music
            #   s -> slack
            #   d -> discord
            #   w -> wofi app launcher
            # Any of these will exit back to normal mode automatically
            # Esc/Enter still works as manual exit

            submap = Application

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
            # Entered via Master: s
            # Inside:
            #   u -> volume up
            #   d -> volume down
            #   m -> mute
            #   b -> brightness down
            #   B -> brightness up (Shift+b)
            #   l -> lock
            #   p -> power menu / shutdown
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
      # Entered via Master: g
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

      # (Optional) you can keep these as backup exits if you like:
      bindd = ,escape, Exit Scratchpad mode, submap, reset
      bindd = ,return, Exit Scratchpad mode, submap, reset


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

        bezier =
          [ "winOut, 0.10, 0.90, 0.15, 1.00" "softIO, 0.25, 0.80, 0.20, 1.00" ];

        animation = [
          "windows,     1, 6,  winOut,  popin 80%"
          "windowsOut,  1, 5,  winOut,  popin 80%"
          "border,      1, 8,  softIO"
          "borderangle, 1, 8,  softIO"
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
        "[workspace special:steam silent] steam"
        "[workspace special:notes silent] obsidian"
        "eww -c ~/.config/eww-which-key daemon"
        "hyprctl plugin load ${
          inputs.hyprhook.packages.${pkgs.system}.hyprhook
        }/lib/libHyprhook.so"
      ];

      bind = [
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mainMod, Return, exec, ghostty"
        "$mainMod, slash, exec, ${./wofi-window-switch.sh}"
        "$mainMod, Q, killactive,"
        "$mainMod CTRL, E, exec, dolphin"
        "$mainMod, F, togglefloating,"
        "$mainMod, P, togglefloating,"
        "$mainMod, P, pin,"
        "ALT, Space, exec, wofi -i --show drun"
        "$mainMod, S, togglesplit,"
        "$mainMod, Tab,  cyclenext"
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
        "$mainMod, Space, submap, Master"
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
        "$mainMod SHIFT, R, movetoworkspacesilent,special:notes"
        "$mainMod, R, togglespecialworkspace,notes"
        "$mainMod SHIFT, T, movetoworkspacesilent,special:slack"
        "$mainMod, T, togglespecialworkspace,slack"
        "$mainMod SHIFT, G, movetoworkspacesilent,special:music"
        "$mainMod, G, togglespecialworkspace,music"
        "$mainMod SHIFT, W, movetoworkspacesilent,special:steam"
        "$mainMod, W, togglespecialworkspace,steam"
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
