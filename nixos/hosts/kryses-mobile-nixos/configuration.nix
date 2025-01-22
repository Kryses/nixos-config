# Version: "Pre Update Config"
{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../packages.nix
    ../../modules/bundle.nix
  ];

  disabledModules = [
    ./modules/xserver.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  boot.blacklistedKernelModules = [
    "intel-ipu6"
    "intel-ipu6-isys"
  ];

  programs.nix-ld.enable = true;
  services.openssh.enable = true;
  nixpkgs.overlays = [ inputs.polymc.overlay ];

  networking.hostName = "kryses-mobile-nixos"; # Define your hostname.
  networking.extraHosts = ''
    192.168.1.231 ayon.work.local
    138.43.161.207 vpn.kryses.com
  '';
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  time.timeZone = "America/New_York"; # Set your time zone.
  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties.

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes

  system.stateVersion = "23.05"; # Don't change it bro
}
