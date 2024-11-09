{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "nouveau" ];
  boot.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_drm"
        "nvidia_uvm"
  ];
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ]; 
}
