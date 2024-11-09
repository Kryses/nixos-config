{ inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./modules/bundle.nix
  ];

  disabledModules = [
    ./modules/xserver.nix
  ];

  services.openssh.enable = true;
  nixpkgs.overlays = [ inputs.polymc.overlay ];

  networking.hostName = "kryses-nixos"; # Define your hostname.

  time.timeZone = "America/New_York"; # Set your time zone.

  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties.

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes

  system.stateVersion = "23.05"; # Don't change it bro
}
