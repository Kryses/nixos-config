{ pkgs, ... }:
{
  qt = {
    enable = true;

    # Make Qt follow GTK’s palette where possible
    platformTheme.name = "gtk";

    # Some Qt apps use their own style; this still nudges them
    style = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
  };
}

