{ inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../packages.nix
    ../../modules/bundle.nix
    ../../hardware/nvidia.nix
  ];

  disabledModules = [
    ../../modules/xserver.nix
  ];
  programs.nix-ld.enable = true;
  services.openssh.enable = true;
  nixpkgs.overlays = [ inputs.polymc.overlay ];

  networking.hostName = "kryses-nixos"; # Define your hostname.
  networking.extraHosts = ''
    192.168.1.231 ayon.work.local
  '';
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  time.timeZone = "America/New_York"; # Set your time zone.
  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties.
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes
  system.stateVersion = "23.05"; # Don't change it bro
}
