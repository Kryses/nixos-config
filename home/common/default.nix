{pkgs, ...}: {
  imports = [
    ./dotfiles
    # ./applications
    ./desktop
    ./cli
    # ../../home-manager/home.nix
  ];
  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "25.05";
  };
}
