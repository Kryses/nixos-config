{pkgs, ...}: {
  imports = [
    ./git
    ./nushell
    ./ohmyposh
    ./btop
    ./zoxide
    ./yazi
    ./zellij
    ./task
  ];
}
