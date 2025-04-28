{
  services.syncthing = {
    enable = true;
    user = "kryses";
    group = "users";
    dataDir = "/home/kryses/.local/share/syncthing";
    configDir = "/home/kryses/.config/syncthing";
    settings = {
      user = "kryses";
      password = "cxp129";
    };
  };
}
