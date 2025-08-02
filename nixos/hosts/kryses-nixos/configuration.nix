{ inputs, pkgs, channels, config, ... }: {
  imports = [
    ./hardware.nix
    ../../packages.nix
    ../../modules/bundle.nix
    ../../hardware/nvidia.nix
  ];

  disabledModules = [
    ../../modules/xserver.nix
  ];
  programs.nix-ld.enable = true;
  services.openssh.enable = true;

  services.speechd.enable = true;
  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    searxng
  ];
}
