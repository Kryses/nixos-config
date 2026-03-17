{
  services.syncthing = {
    enable = true;
    user = "kryses";
    group = "users";
    dataDir = "/home/kryses/.local/share/syncthing";
    settings = {
      user = "kryses";
      password = "cxp129";
    };
  };
}
