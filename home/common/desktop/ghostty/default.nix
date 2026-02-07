
{ pkgs, ... }: {
  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    font-family = "JetbrainsMonoNerdFont";
    theme = "Catppuccin Macchiato";
    command = "zellij";
  };
}
