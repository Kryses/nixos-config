{inputs, outputs, config, pkgs, ...}:
{
  imports = [
    ../common
    ../common/modules/audio.nix
    ../common/modules/bluetooth.nix
    ../common/modules/nvidia.nix
    ../common/modules/podman.nix
    ../common/modules/gamemode.nix
    ../common/modules/ollama.nix
    ../common/modules/podman.nix
    ../common/modules/open-webui-container.nix
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
