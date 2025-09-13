
{pkgs, ...}: {
  imports = [
    ./hyprland
    ./hyprlock
    ./waybar
    ./wofi
    ./mako
    ./cursor
    ./qt
  ];
}
