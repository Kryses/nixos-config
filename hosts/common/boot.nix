{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 1;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
  boot.blacklistedKernelModules = [
    "intel-ipu6"
    "intel-ipu6-isys"
  ];
}
