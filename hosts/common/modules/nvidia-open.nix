{ config, lib, pkgs, ... }:

# Nvidia Related settings
{

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" "fbdev=1" ];

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.open = true;
  hardware.graphics = {
    enable = true;
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
