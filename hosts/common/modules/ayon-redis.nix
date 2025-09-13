{ config, lib, pkgs, ... }:
{
  image = "docker.io/redis:alpine";
  autoStart = true;
  ports = [
    "6379:6379"
  ];

  extraOptions = [
    "--pull=newer" # Pull if the image on the registry is newer
    "--name=ayon-redis"
    "--hostname=ayon-redis"
    "--network=host"
    "--add-host=host.containers.internal:host-gateway"
  ];
}
