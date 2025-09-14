{ config, lib, pkgs, ... }:
{
  image = "docker.io/postgres:13.22-alpine";
  autoStart = true;
  volumes = [
    "/home/kryses/.local/share/ayon/db:/var/lib/postgresql/data"
    "/etc/localtime:/etc/localtime:ro"
  ];
  ports = [
    "5432:5432"
  ];
  environment = {
    "TZ" = "America/New_York";
    "POSTGRES_USER" = "ayon";
    "POSTGRES_PASSWORD" = "ayon";
    "POSTGRES_DB" = "ayon";
  };

  extraOptions = [
    "--pull=newer" # Pull if the image on the registry is newer
    "--name=ayon-postgres"
    "--hostname=ayon-postgres"
    "--network=host"
    "--add-host=host.containers.internal:host-gateway"
  ];
}
