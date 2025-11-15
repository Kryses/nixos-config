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

  # hardware.nvidia.prime = {
  #   sync.enable = true;
  #   nvidiaBusId = "PCI:4:0:0";
  #   intelBusId = "PCI:0:2:0";
  # };
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0775 kryses root qemu-libvirtd -"
  ];
  networking = {
    hostName = "kryses-brokkr";
    # usePredictableInterfaceNames = false;
    # interfaces.eth1.ipv4.addresses = [{
    #   address = "192.168.1.200";
    #   prefixLength = 24;
    # }];
    # nameservers = ["1.1.1.1" "8.8.8.8"];
    # defaultGateway = "192.168.1.1";
  };

  networking.hosts = {
    "192.168.1.201" = ["kryses.local.ai"];
  };
  
  services.speechd.enable = true;
  security.pam.services.hyprlock = { };
  # environment.systemPackages = with pkgs; [
  #   searxng
  # ];
}
