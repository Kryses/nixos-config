{

  imports = [
    ./zsh.nix
    ./nushell.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "23.11";
  };
  home.file = {
    ".config/nushell/aliases.nu".source = ~/dotfiles/nushell/aliases.nu;
    ".config/nushell/config.nu".source = ~/dotfiles/nushell/config.nu;
    ".config/nushell/env.nu".source = ~/dotfiles/nushell/env.nu;
    ".config/nushell/zoxide.nu".source = ~/dotfiles/nushell/zoxide.nu;
    ".config/ohmyposh".source = ~/dotfiles/ohmyposh;
    ".config/tmux/custom".source = ~/dotfiles/tmux/custom;
  };
}
