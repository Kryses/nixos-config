{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme    = "Tokyonight-Dark";
      icon-theme   = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Ice";
    };
  };

  # Optional extra hammer for stubborn apps:
  home.sessionVariables.GTK_THEME = "Tokyonight-Dark";  # works around some GTK4/libadwaita edge cases :contentReference[oaicite:3]{index=3}
}

