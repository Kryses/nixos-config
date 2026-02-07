
{lib, ...}: {
  imports = [
    ../../home/common
  ];

  programs.looking-glass-client = {
      enable = true;
      settings = {
      app = {
        allowDMA = true;
        shmFile = "/dev/kvmfr0";
        capture = "nvfbc";
      };
      win = {
        fullScreen = false;
        showFPS = false;
        jitRender = true;
        backend = "x11";
      };
      spice = {
        enable = true;
        audio = true;
      };
      input = {
        rawMouse = true;
      };
      };
    };

  wayland.windowManager.hyprland.settings = {
    monitor =[
        "DP-2,5120x1440@60,auto,1"
        "DP-3,5120x1440@60,auto-up,1"
    ];
  env = [
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "QT_QPA_PLATFORM,wayland"
    "LIBVA_DRIVER_NAME,nvidia"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "GBM_BACKEND,nvidia-drm"
    "__NV_PRIME_RENDER_OFFLOAD,1"
    "__VK_LAYER_NV_optimus,NVIDIA_only"
  ];

    # Windows RDP workspace - auto-launch remmina to win10-halon
    # Use mkForce to override the base workspace list completely
    workspace = lib.mkForce [
        "1, monitor:DP-2"
        "2, monitor:DP-2"
        "3, monitor:DP-2"
        "4, monitor:DP-2"
        "5, monitor:DP-2"
        "6, monitor:DP-3"
        "7, monitor:DP-3"
        "8, monitor:DP-3"
        "9, monitor:DP-3"
        "10, monitor:DP-3"
        "special:windows, on-created-empty:remmina -c ~/.local/share/remmina/work_rdp_win10-halon_192-168-1-232.remmina"
        "special:slack, on-created-empty:foot"
        "special:music, on-created-empty:foot"
        "special:steam, on-created-empty:foot"
        "special:notes, on-created-empty:foot"
        "special:game, on-created-empty:foot"
        "special:term, on-created-empty:ghostty --title=TermPad"
        "special:zen, on-created-empty:zen"
    ];

    # Window rules for Windows RDP - fullscreen
    windowrule = [
      "match:class org.remmina.Remmina, match:title win10-halon, fullscreen on, workspace special:windows"
    ];
  };

  # extraConfig is appended AFTER settings, so unbind then rebind works here
  wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
    # Override SUPER+W from slack to Windows RDP on this host
    unbind = SUPER, W
    unbind = SUPER CTRL, W
    bind = SUPER, W, togglespecialworkspace, windows
    bind = SUPER CTRL, W, movetoworkspacesilent, special:windows

    # Swap E and B: Slack to E, Spotify to B
    unbind = SUPER, E
    unbind = SUPER CTRL, E
    bind = SUPER, E, togglespecialworkspace, slack
    bind = SUPER CTRL, E, movetoworkspacesilent, special:slack
    bind = SUPER, B, togglespecialworkspace, music
    bind = SUPER CTRL, B, movetoworkspacesilent, special:music
  '';
}
