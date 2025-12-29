{inputs, outputs, config, pkgs, ...}:
{
  imports = [
    ../common
    ../common/modules/audio.nix
    ../common/modules/bluetooth.nix
    ../common/modules/podman.nix
    ../common/modules/arm.nix
    ../common/modules/cloudflare-warp.nix
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
}
