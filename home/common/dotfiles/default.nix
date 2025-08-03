{pkgs, ...}: {
  home.file = {
    ".config/satty".source = ./satty;
    ".config/yazi".source = ./yazi;
    ".config/zellij".source = ./zellij;
    ".config/nvim/lua".source = ./nvim/lua;
    ".config/nvim/init.lua".source = ./nvim/init.lua;
    ".config/nvim/neovim.yml".source = ./nvim/neovim.yml;
    ".config/nvim/selene.toml".source = ./nvim/selene.toml;
    ".gitignore_global".source = ./.gitignore_global;
    ".gitconfig".source = ./gitconfig;
    "scripts".source = ./scripts;
  };
}
