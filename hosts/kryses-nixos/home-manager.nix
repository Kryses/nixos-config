
{lib, ...}: {
  imports = [
    ../../home-manager/home.nix
  ];

  # wayland.windowManager.hyprland = {
  #   settings.input = {
  #     sensitivity = lib.mkForce 0.3;
  #   };
  # };
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
