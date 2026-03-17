
{lib, ...}: {
  imports = [
    ../../home/common
  ];

  wayland.windowManager.hyprland.settings = {
    monitor =[
        "eDP-1,1920x1200@60,0x0,1"
    ];
    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XCURSOR_SIZE,36"
      "QT_QPA_PLATFORM,wayland"
      "XDG_SCREENSHOTS_DIR,~/wallpaper"
    ];

    # Windows RDP workspace - auto-launch remmina to win11-halon
    workspace = [
      "special:windows, on-created-empty:remmina -c ~/.local/share/remmina/group_rdp_win11-halon_192-168-1-232.remmina"
    ];

    # Window rules for Windows RDP - fullscreen
    windowrule = [
      "match:class org.remmina.Remmina, match:title win11-halon, fullscreen on, workspace special:windows"
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
  programs.ghostty.settings = {
    font-size = 10;
  };
  #
  # monitors = [
  #   {
  #     name = "eDP-1";
  #     width = 3072;
  #     height = 1920;
  #     x = 0;
  #     scale = 1.5;
  #   }
  # ];
}
