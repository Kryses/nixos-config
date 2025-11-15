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

  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
  services.speechd.enable = true;
  security.pam.services.hyprlock = { };

  networking = {
    hostName = "kryses-kirk";
    usePredictableInterfaceNames = false;
    interfaces.eth1.ipv4.addresses = [{
      address = "192.168.1.201";
      prefixLength = 24;
    }];
    nameservers = ["1.1.1.1" "8.8.8.8"];
    defaultGateway = "192.168.1.1";
  };
  
  # environment.systemPackages = with pkgs; [
  #   searxng
  # ];
}
