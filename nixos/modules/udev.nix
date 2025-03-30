{ pkgs, inputs, ... }:
{
  services.udev = {
    enable = true;
    packages = [
      pkgs.qmk
      pkgs.qmk-udev-rules
      pkgs.qmk_hid
      pkgs.via
      pkgs.vial
      ];

  };
}
