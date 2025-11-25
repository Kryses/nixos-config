{ inputs, ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun,run,wallpaper";
      location = "top";
      allow_markup = true;
      allow_images = true;
      insensitive= true;
      width = "20%";
      key_up = "Ctrl-p";
      key_down = "Ctrl-n";
    };
    style = builtins.readFile ./style.css;
  };
  home.file = {
    ".config/wofi/wallpaper.conf".source = ./wallpaper/wallpaper.conf;
    ".config/wofi/wofi-wallpaper-selector.sh".source = ./wallpaper/wofi-wallpaper-selector.sh;
    ".config/wofi/wallpaper-style.css".source = ./wallpaper/wallpaper-style.css;
    ".config/wofi/assets".source = ./wallpaper/assets;
    ".config/wofi/assets/screenshot.png".source = ./wallpaper/assets/screenshot.png;
    ".config/wofi/assets/shuffle.png".source = ./wallpaper/assets/shuffle.png;
  };
}
