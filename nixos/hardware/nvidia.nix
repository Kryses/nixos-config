{ config, lib, pkgs, ... }:

# Nvidia Related settings
{

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" "fbdev=1" ];

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  services.xserver = {
    videoDrivers = lib.mkForce [ "nvidia" ];
    # Manualy setting dpi, for nvidia prime sync
    dpi = 96;
    # Fix Screen tearing (may cause some others problems)
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };

}
