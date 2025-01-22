{ pkgs, ... }: {
  virtualisation = {
    containers.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        open-webui = import ./open-webui-container.nix;
        llama-factory = import ./llama-factory.nix;
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  hardware.nvidia-container-toolkit.enable = true;
}
