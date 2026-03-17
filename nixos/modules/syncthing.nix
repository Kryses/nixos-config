{
  services.syncthing = {
    enable = true;
    user = "kryses";
    group = "users";
    dataDir = "/home/kryses/.local/share/syncthing";
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      user = "kryses";
      password = "cxp129";
    };
  };
}
