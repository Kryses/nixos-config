{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "25.05";
  };
  home.file = {
    # ".config/ohmyposh".source = ~/dotfiles/ohmyposh;
    ".config/tmux/custom".source = ~/dotfiles/tmux/custom;
    ".config/tmux/scripts".source = ~/dotfiles/tmux/scripts;
    ".config/bugwarrior".source = ~/dotfiles/bugwarrior;
    ".config/task".source = ~/dotfiles/task;
    ".config/satty".source = ./dotfiles/satty;
    ".config/yazi".source = ./dotfiles/yazi;
    ".gitignore_global".source = ./dotfiles/.gitignore_global;
    ".gitconfig".source = ./dotfiles/gitconfig;
    "scripts".source = ./scripts;
    ".taskrc".source = ~/dotfiles/.taskrc;
  };
  systemd.user.services.stable-diffusion-web-ui = {
    Unit = {
      Description = "Stable Diffusion Web Ui";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      Restart = "always";
      ExecStart = "${pkgs.writeShellScript "stable-diffusion-web-ui" ''
        stable-diffusion-webui --api --share --listen

      ''}";
    };
  };
}
