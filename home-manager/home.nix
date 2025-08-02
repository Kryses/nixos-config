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
    ".config/satty".source = ./dotfiles/satty;
    ".config/yazi".source = ./dotfiles/yazi;
    ".config/zellij".source = ./dotfiles/zellij;
    ".config/nvim/lua".source = ./dotfiles/nvim/lua;
    ".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
    ".config/nvim/neovim.yml".source = ./dotfiles/nvim/neovim.yml;
    ".config/nvim/selene.toml".source = ./dotfiles/nvim/selene.toml;
    ".gitignore_global".source = ./dotfiles/.gitignore_global;
    ".gitconfig".source = ./dotfiles/gitconfig;
    "scripts".source = ./scripts;
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
