{
  services.pcscd.enable = true;
  programs.gnupg.agent.pinentryPackage = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
}
