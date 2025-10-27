{config, pkgs,  ... }:
let configDir = "${config.xdg.configHome}/nushell";

in {
  # # home.file."${configDir}/aliases.nu".source = ./aliases.nu;
  # home.file."${configDir}/oh-my-posh.nu".source = ./oh-my-posh.nu;
  # home.file."${configDir}/env.nu".source = ./env.nu;
  # # home.file."${configDir}/zoxide.nu".source = ./zoxide.nu;
  # home.file."${configDir}/omp-kryses.toml".source = ./omp-kryses.toml;

  home.sessionVariables = {
    _ZO_DATA_DIR = "~/.local/share";
  };
  programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      query
      gstat
      polars
    ];
    extraConfig = let
      conf = builtins.toJSON {
        show_banner = false;
        edit_mode = "vi";
        ls.clickable_links = true;
        rm.always_trash = true;

        table = {
          mode = "rounded";
          index_mode = "always";
          header_on_separator = false;
        };
        cursor_shape = { 
          vi_insert = "line";
          vi_normal = "block";
        };
        display_errors = {
          exit_code = false;
        };
        menus = [
          {
            name = "completeion_menu";
            only_buffer_difference = false;
            marker = "? ";
            type = {
              layout = "columnar";
              columns = 4;
              col_padding = 2;
            };
            style = {
              text = "magenta";
              selected_text = "blue_reverse";
              description_text = "yellow";
            };
          }
        ];
        keybindings = [
          {
            name = "accept";
            modifier = "control";
            keycode = "char_l";
            mode = "vi_insert";
            event = {
              send = "HistoryHintComplete";
            };
          }
          {
            name = "accept_word";
            modifier = "control_shift";
            keycode = "char_l";
            mode = "vi_insert";
            event = {
              send = "HistoryHintWordComplete";
            };
          }
        ];
      }; 
    in ''
      $env.config = ${conf};
    '';
    shellAliases = {
      gg = "lazygit";
      g = "git";
      c = "clear";
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      test-build = "sudo nixos-rebuild test --impure --flake ~/documents/nixos/nix";
      start-timer = "nu ~/scripts/run_timer.nu";
      switch-build = "sudo nixos-rebuild switch --impure --flake ~/documents/nixos/nix";
      update-build = "nix flake update ~/documents/nixos/nix";
      mount_work = "nix flake update ~/documents/nixos/nix";
      ta = "task add";
      ts = "task start";
      tss = "task stop";
      tt = "task next";
      ttu = "taskwarrior-tui";
      tw = "timew";
      twd = "timew day";
      tws = "timew summary";
    };
    environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "  ";
        PROMPT_INDICATOR_VI_NORMAL = "∙ ";
        PROMPT_COMMAND = "";
        PROMPT_COMMAND_RIGHT = "";
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = "${pkgs.nushell}/bin/nu";
        EDITOR = "nvim";
        VISUAL = "nvim";
        POSH_THEME = "${configDir}/omp-kryses.toml";
    };

  };
  
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;

}
