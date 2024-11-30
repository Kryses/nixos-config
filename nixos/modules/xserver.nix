{
  services.xserver = {
    enable = true;
    windowManager.herbstluftwm.enable = true;
    # displayManager = {
    #   sddm = {
    #     enable = true;
    #     wayland.enable = true;
    #     theme = "Elegant";
    #   };
    # };

    xkb.layout = "us";
    xkb.variant = "";


    deviceSection = ''Option "TearFree" "True"'';
  };
  
    services.libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat";
    };
}
