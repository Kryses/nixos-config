{pkgs, ...}: {
  imports = [
    ./git
    ./nushell
    ./ohmyposh
    ./htop
    ./btop
    ./zoxide
    ./yazi
    ./zellij
  ];
}
