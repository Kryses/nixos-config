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
    ".config/ohmyposh".source = ~/dotfiles/ohmyposh;
    ".config/tmux/custom".source = ~/dotfiles/tmux/custom;
  };
}
