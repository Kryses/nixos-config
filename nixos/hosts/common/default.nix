{
  inputs,
  outputs,
  config,
  lib,
  ...
}:{
  imports = [
    ./boot.nix
    ./openssh.nix
    ./greetd.nix
    inputs.home-manager.nixosModules.home-manager

  ];
  services.ntp.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties.
  system.stateVersion = "23.05"; # Don't change it bro

  nix.extraOptions = ''
    trusted-users = root kryses
  '';

  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 10d";
    };

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = false;
      warn-dirty = false;
      trusted-users = ["kryses"];
    };
  };
}
