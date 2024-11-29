{ inputs, ...}:
{
  programs.zoxide.enable = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.zoxide.options = [
  "--cmd cd"
  ];
  home.sessionVariables = {
    _ZO_DATA_DIR = "~/.local/share";
  };
}
