
{pkgs, ...}: {
  imports = [
    ./hyprland
    ./ghostty
    ./hyprlock
    ./waybar
    ./wofi
    ./mako
    ./cursor
    ./qt
    # ./gtk
  ];
}
