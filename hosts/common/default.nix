{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./openssh.nix
    ./greetd.nix
    ./modules/gtk-theme.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  services.ntp.enable = true;
  time.timeZone = "America/New_York";
  system.stateVersion = "23.05"; # Don't change it bro

  nix.extraOptions = ''
    trusted-users = root kryses
  '';

  nixpkgs.config.allowUnfree = true;

  home-manager.backupFileExtension = "backup";

  networking = {
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    defaultGateway = "192.168.1.1";
  };
  networking.networkmanager.insertNameservers = [ "192.168.1.80" ];

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
      trusted-users = [ "kryses" ];
    };
  };

  # --- SMB mount bits start here ---

  # Make sure CIFS is supported
  boot.supportedFilesystems = [ "cifs" ];

  # Optional: tools like mount.cifs
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  # Mount the SMB share at /mnt/mirmir
  fileSystems."/mnt/mimir" = {
    device = "//192.168.1.203/Mimir";
    fsType = "cifs";

    # Adjust uid/gid to match your user if different
    options = [
      "credentials=/etc/nixos/smb-mimir-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "file_mode=0644"
      "dir_mode=0755"
      "x-systemd.automount"
      "noauto"
      "nofail"
    ];
  };
}

