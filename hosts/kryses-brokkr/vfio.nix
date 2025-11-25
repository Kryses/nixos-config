{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  vfioOverrideScript = pkgs.writeShellScript "vfio-pci-override.sh" ''
    #! /bin/sh

    # Make sure vfio-pci is available
    modprobe -i vfio-pci 2>/dev/null || true

    # Find all GPUs that are *not* the boot VGA
    for i in /sys/bus/pci/devices/*/boot_vga; do
        [ -f "$i" ] || continue

        if [ "$(cat "$i")" -eq 0 ]; then
            # /sys/bus/pci/devices/0000:04:00.0/boot_vga -> /sys/bus/pci/devices/0000:04:00.0
            GPU="$(dirname "$i")"

            # Assume .0 = GPU, .1 = audio, .2 = USB/RGB or similar
            AUDIO="$(echo "$GPU" | sed 's/\.0$/.1/')"
            USB="$(echo "$GPU" | sed 's/\.0$/.2/')"

            for DEV in "$GPU" "$AUDIO" "$USB"; do
                [ -d "$DEV" ] || continue

                # Get BDF like 0000:04:00.0 from the path
                DEV_BDF="$(basename "$DEV")"

                # If already bound to a driver (nvidia, snd_hda_intel, etc), unbind it
                if [ -L "$DEV/driver" ]; then
                    DRIVER="$(basename "$(readlink "$DEV/driver")")"
                    echo "$DEV_BDF" > "/sys/bus/pci/drivers/$DRIVER/unbind" 2>/dev/null || true
                fi

                # Override to vfio-pci and bind it
                echo "vfio-pci" > "$DEV/driver_override" 2>/dev/null || true
                echo "$DEV_BDF" > /sys/bus/pci/drivers/vfio-pci/bind 2>/dev/null || true
            done
        fi
    done
  '';
in
{
  imports = [
    inputs.nixos-vfio.nixosModules.vfio
    ../common/modules/libvirt.nix
  ];
  # boot.kernelPackages = pkgs.linuxPackages_6_10;
  boot.kernelParams = [
    "intel_iommu=on,sm_on"
    "iommu=pt"
    "intel_iommu=igfx_off"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"
  ];

  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
  ];

  # Don’t rewrite vfio-pci’s install line anymore
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=128
  '';

  # Put the script into the initrd root as /vfio-pci-override.sh
  boot.initrd.extraFiles."/vfio-pci-override.sh".source = vfioOverrideScript;

  # Run it in stage-1, after other preDeviceCommands from nixos-vfio (mkAfter)
  boot.initrd.preDeviceCommands = lib.mkAfter ''
    /vfio-pci-override.sh
  '';

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
    # devices = [
    #   "10de:2702"
    #   "10de:22bb"
    # ];
  };

virtualisation.kvmfr = {
  enable = true;
  devices = lib.singleton {
    size = 128;
    permissions = {
      # Owner/group that QEMU (libvirt) will run under
      user = "qemu-libvirtd";
      group = "qemu-libvirtd";
      mode = "0660";
    };
  };
};
users.users.kryses.extraGroups = [
  "qemu-libvirtd"
];
  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
