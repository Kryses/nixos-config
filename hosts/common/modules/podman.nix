{ pkgs, ... }: {
  virtualisation = {
    containers.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        open-webui = import ./open-webui-container.nix;
        # llama-factory = import ./llama-factory.nix;
        # ayon-postgre = import ./ayon-posgres.nix;
        # ayon-redis = import ./ayon-redis.nix;
        # ayon = import ./ayon-server.nix;
        # pihole = import ./pihole.nix;
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = with pkgs; [
    podman-tui
    docker-compose
  ];

}
