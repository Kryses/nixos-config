{inputs, outputs, config, pkgs, ...}:
{
  imports = [
    ../common
    ../common/modules/audio.nix
    ../common/modules/bluetooth.nix
    ../common/modules/libvirt.nix
     ./vfio.nix
    ../common/modules/nvidia-open.nix
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
  networking.hostName = "kryses-brokkr";

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
# sudo mount -t cifs //192.168.1.232/development /home/kryses/documents/work -o username="cprovencher,password=Gr00tNT!na2021,uid=1000,gid=1000,iocharset=utf8,file_mode=0664,dir_mode=0755,mfsymlinks"
