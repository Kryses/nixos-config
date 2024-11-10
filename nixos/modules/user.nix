{ pkgs, ... }: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.kryses= {
      isNormalUser = true;
      description = "Kryses";
      extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" ];
      packages = with pkgs; [];
      shell = pkgs.nushell;
    };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "kryses";
}
