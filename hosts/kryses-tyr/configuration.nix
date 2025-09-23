{ inputs, pkgs, channels, config, ... }: {
  imports = [
    ./hardware.nix
    ../../nixos/packages.nix
    ../../nixos/modules/bundle.nix
  ];

  disabledModules = [
    ../../modules/xserver.nix
  ];
  programs.nix-ld.enable = true;
  services.openssh.enable = true;

  services.speechd.enable = true;
  security.pam.services.hyprlock = { };

  networking = {
    hostName = "kryses-tyr";
    nameservers = ["1.1.1.1" "8.8.8.8"];
    defaultGateway = "192.168.1.1";
  };
  
  # environment.systemPackages = with pkgs; [
  #   searxng
  # ];
}
