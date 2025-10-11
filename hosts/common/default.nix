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
  system.stateVersion = "23.05"; # Don't change it bro

  nix.extraOptions = ''
    trusted-users = root kryses
  '';

  # config.allowUnfree = true;
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home-manager.backupFileExtension = "backup";

  networking = {
    nameservers = [ 
      "8.8.8.8" 
      "1.1.1.1" 
    ];
    defaultGateway = "192.168.1.1";
  };
  networking.networkmanager.insertNameservers = ["192.168.1.80"];

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
