{
  services.pcscd.enable = true;
  programs.gnupg.agent.pinentryPackage = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };
}
