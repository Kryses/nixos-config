{inputs, outputs, config, pkgs, ...}:
{
  imports = [
    ../common
    ../common/modules/audio.nix
    ../common/modules/bluetooth.nix
    # ../common/modules/opentabletdriver.nix
    ../common/modules/nvidia.nix
    ../common/modules/ollama.nix
    ../common/modules/searx.nix
    ../common/modules/podman.nix
    ../common/modules/gamemode.nix
    ../common/modules/ayon
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
  networking.hostName = "kryses-nixos";
}
