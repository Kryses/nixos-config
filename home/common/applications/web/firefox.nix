{
  inputs,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enabled = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };
}
