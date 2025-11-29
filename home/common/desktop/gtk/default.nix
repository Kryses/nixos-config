{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      tokyonight-gtk-theme
      papirus-icon-theme
      bibata-cursors
    ];
  };

  gtk = {
    enable = true;

    theme = {
      name = "Tokyonight-Dark";   # matches your screenshot
      package = pkgs.tokyonight-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 32;
    };

    font = {
      name = "Inter";
      size = 11;
    };
  };

  # GTK4 / libadwaita copies
  xdg.configFile."gtk-4.0/gtk.css".source =
    "${pkgs.tokyonight-gtk-theme}/share/themes/Tokyonight-Dark/gtk-4.0/gtk.css";
  xdg.configFile."gtk-4.0/gtk-dark.css".source =
    "${pkgs.tokyonight-gtk-theme}/share/themes/Tokyonight-Dark/gtk-4.0/gtk-dark.css";
  xdg.configFile."gtk-4.0/assets".source =
    "${pkgs.tokyonight-gtk-theme}/share/themes/Tokyonight-Dark/gtk-4.0/assets";


  # Force exporting theme variables for Hyprland
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark";     # ensures GTK3 apps obey
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "32";
  };
  #
  # # Help libadwaita apps choose dark mode
  # dconf.settings."org/gnome/desktop/interface" = {
  #   color-scheme = "prefer-dark";
  # };
}

