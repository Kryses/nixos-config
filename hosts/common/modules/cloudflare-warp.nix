{ config, pkgs, ... }:

{
  services.cloudflare-warp = {
    enable = true;

    # Usually fine to leave default, but this avoids confusion:
    openFirewall = true;
    # udpPort = 2408; # default is usually fine; only set if you need it
  };

  environment.systemPackages = with pkgs; [
    cloudflare-warp
  ];
}

