{pkgs, ...}:
{
  environment.systemPackages = [pkgs.graphite-gtk-theme];
  environment.variables = {
    GTK_THEME = "graphite";
  };
}
