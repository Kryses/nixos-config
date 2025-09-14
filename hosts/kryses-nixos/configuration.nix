{ inputs, pkgs, channels, config, ... }: {
  imports = [
    ./hardware.nix
    ../../nixos/packages.nix
    ../../nixos/modules/bundle.nix
    ../../nixos/hardware/nvidia.nix
  ];

  disabledModules = [
    ../../modules/xserver.nix
  ];
  programs.nix-ld.enable = true;
  services.openssh.enable = true;

  networking.interfaces.enp4s0.ipv4.addresses = [{
    address = "192.168.1.200";
    prefixLength = 24;
  }];

  networking.hosts = {
    "192.168.1.201" = ["kryses.local.ai"];
  };
  
  services.speechd.enable = true;
  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    searxng
  ];
}
