{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.dolphin
  ];
}
