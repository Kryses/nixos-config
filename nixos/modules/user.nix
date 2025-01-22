{ pkgs, ... }: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.kryses= {
      isNormalUser = true;
      description = "Kryses";
      extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "docker"];
      packages = with pkgs; [];
      shell = pkgs.nushell;
    };
  };
}
