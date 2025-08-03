# Version: "Pre Update Config"
{ inputs, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../nixos/packages.nix
    ../../nixos/modules/bundle.nix
  ];

  disabledModules = [
    ./modules/xserver.nix
  ];


  programs.nix-ld.enable = true;
  services.openssh.enable = true;
  nixpkgs.overlays = [ inputs.polymc.overlay ];

  networking.extraHosts = ''
    192.168.1.231 ayon.work.local
    138.43.161.207 vpn.kryses.com
  '';
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


  system.stateVersion = "23.05"; # Don't change it bro
}
