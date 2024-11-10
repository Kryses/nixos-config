{

  imports = [
    ./zsh.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "23.11";
  };
  home.file = {
    ".config/nushell/zoxide.nu".source = ~/dotfiles/nushell/zoxide.nu;
    ".config/ohmyposh".source = ~/dotfiles/ohmyposh;
    ".config/tmux/custom".source = ~/dotfiles/tmux/custom;
  };
}
