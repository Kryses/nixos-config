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

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0775 kryses root qemu-libvirtd -"
  ];
  networking = {
    hostName = "kryses-brokkr";
  };

  networking.hosts = {
    "192.168.1.201" = ["kryses.local.ai"];
  };
  
  services.speechd.enable = true;
  security.pam.services.hyprlock = { };
}
