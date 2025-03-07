{config,  ... }:
let configDir = "${config.xdg.configHome}/nushell";

in {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    shellAliases = {
      # cd = "z";
    };
  };
  home.file."${configDir}/aliases.nu".source = ./aliases.nu;
  home.file."${configDir}/oh-my-posh.nu".source = ./oh-my-posh.nu;
  home.file."${configDir}/zoxide.nu".source = ./zoxide.nu;

  home.sessionVariables = {
    _ZO_DATA_DIR = "~/.local/share";
  };
}
