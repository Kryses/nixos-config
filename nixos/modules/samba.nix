{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "follow symlinks" = "yes";
        "wide links" = "yes";
        "unix extentions" = "yes";
        securityType = "user";
      };
      work = {
        "path" = "/home/kryses/work";
        "valid users" = "kryses";
        "public" = "no";
        "read only" = "no";
        "writable" = "yes";
        "create mask" = "0664";
        "directory mask" = "2775";
        "force create mode" = "0664";
        "force directory mode" = "2775";

      };
    };

  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}
