{
  config,
  lib,
  pkgs,
  ...
}: {
  image = "docker.io/ynput/ayon:latest";
  autoStart = true;
  ports = [
    "5001:5000"
  ];
  volumes = [
    "/home/kryses/.local/share/ayon/addons:/addons"
    "/home/kryses/.local/share/ayon/storage:/storage"
  ];
  extraOptions = [
    "--pull=newer" # Pull if the image on the registry is newer
    "--name=ayon"
    "--hostname=ayon"
    "--network=host"
    "--add-host=host.containers.internal:host-gateway"
  ];
}
