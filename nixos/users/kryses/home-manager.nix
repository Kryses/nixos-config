{pkgs, ...}: {
  imports = [
    ../../../home-manager/zsh.nix
    ../../../home-manager/modules/bundle.nix
  ];

  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "25.05";
  };
  home.file = {
    ".config/satty".source = ../../../home-manager/dotfiles/satty;
    ".config/yazi".source = ../../../home-manager/dotfiles/yazi;
    ".config/zellij".source = ../../../home-manager/dotfiles/zellij;
    ".config/nvim/lua".source = ../../../home-manager/dotfiles/nvim/lua;
    ".config/nvim/init.lua".source = ../../../home-manager/dotfiles/nvim/init.lua;
    ".config/nvim/neovim.yml".source = ../../../home-manager/dotfiles/nvim/neovim.yml;
    ".config/nvim/selene.toml".source = ../../../home-manager/dotfiles/nvim/selene.toml;
    ".gitignore_global".source = ../../../home-manager/dotfiles/.gitignore_global;
    ".gitconfig".source = ../../../home-manager/dotfiles/gitconfig;
    "scripts".source = ../../../home-manager/scripts;
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
