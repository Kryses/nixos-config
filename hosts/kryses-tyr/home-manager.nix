
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
  };
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
