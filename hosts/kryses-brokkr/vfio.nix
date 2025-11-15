{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-vfio.nixosModules.vfio
    ../common/modules/libvirt.nix
  ];

  virtualisation.libvirtd = {
    deviceACL = [
      "/dev/kvm"
      "/dev/kvmfr0"
      "/dev/kvmfr1"
      "/dev/kvmfr2"
      "/dev/shm/scream"
      "/dev/shm/looking-glass"
      "/dev/null"
      "/dev/full"
      "/dev/zero"
      "/dev/random"
      "/dev/urandom"
      "/dev/ptmx"
      "/dev/kvm"
      "/dev/kqemu"
      "/dev/rtc"
      "/dev/hpet"
      "/dev/vfio/vfio"
    ];
  };

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.vfio = {
    enable = true;
    IOMMUType = "intel";
    devices = [
      "10de:18cb"
      "10de:2702"
      "10de:22bb"
    ];
  };

  virtualisation.kvmfr = {
    enable = true;
    devices = lib.singleton {
      size = 128;
      permissions = {
        user = "kryses";
        mode = "0777";
      };
    };
  };
  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };

  boot.blacklistedKernelModules = [
    "amdgpu"
    "radeon"
  ];

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];

}
