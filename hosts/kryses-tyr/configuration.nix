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

    # These will go into /etc/resolv.conf when we let Nix manage DNS
    nameservers = [
      # "192.168.1.80"
      "8.8.8.8"
      "1.1.1.1"
    ];

    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];

      # Important: tell NM not to manage resolv.conf and not to use DHCP DNS
      dns = "none";
    };
  };
  # environment.systemPackages = with pkgs; [
  #   searxng
  # ];
}
