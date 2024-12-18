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
    ".config/tmux/scripts".source = ~/dotfiles/tmux/scripts;
    ".config/bugwarrior".source = ~/dotfiles/bugwarrior;
    ".config/task".source = ~/dotfiles/task;
    "scripts".source = ~/dotfiles/scripts;
    ".taskrc".source = ~/dotfiles/.taskrc;
    ".gitignore_global".source = ~/dotfiles/.gitignore_global;
    ".gitconfig".source = ~/dotfiles/gitconfig;
  };
}
