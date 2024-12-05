{ pkgs, ... }:
{
  programs.gnupg.agent.pinentryPackage = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
}
