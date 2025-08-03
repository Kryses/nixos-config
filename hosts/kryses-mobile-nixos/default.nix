{
  inputs,
  outputs,
  config,
  pkgs-stable,
  ...
}: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware.nix
  ];
  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      nixosConfig = config;
    };
    users.kryses = import ./home-manager.nix;

  };
  networking.hostName = "kryses-mobile-nixos";
}
