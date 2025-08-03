{pkgs, ...}: {
  imports = [
    ./dotfiles
    ./modules/desktop
    ./modules/cli
    ../../home-manager/home.nix
  ];
}
