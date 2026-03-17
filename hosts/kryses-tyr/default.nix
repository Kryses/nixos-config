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
  fileSystems."/mnt/work" = {
    device = "//192.168.1.232/dev";
    fsType = "cifs";

    # Adjust uid/gid to match your user if different
    options = [
      "credentials=/etc/nixos/smb-halon-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "file_mode=0644"
      "dir_mode=0755"
      "x-systemd.automount"
      "noauto"
      "nofail"
      "mfsymlinks"
    ];
  };
}
