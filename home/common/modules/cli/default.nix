{pkgs, ...}: {
  imports = [
    ./git
    ./nushell
    ./ohmyposh
    ./htop
    ./zoxide
    ./yazi
  ];
}
