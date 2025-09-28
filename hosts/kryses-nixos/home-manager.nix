
{lib, ...}: {
  imports = [
    ../../home/common
  ];

  wayland.windowManager.hyprland.settings = {
    monitor =[
        "DP-1,5120x1440@60,auto,1"
        "DP-3,5120x1440@60,auto-up,1"
    ];
    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XCURSOR_SIZE,36"
      "QT_QPA_PLATFORM,wayland"
      "XDG_SCREENSHOTS_DIR,~/wallpaper"
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];
  };
}
