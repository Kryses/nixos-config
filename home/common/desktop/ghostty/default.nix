
{ pkgs, ... }: {
  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    font-family = "JetbrainsMonoNerdFont";
    theme = "catppuccin-macchiato";
  };
}
