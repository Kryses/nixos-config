{ pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "python-2.7.18.8" "electron-25.9.0" ];
  };
  environment.systemPackages = [
    # Desktop apps
    # (pkgs.callPackage ./packages/splashtop/default.nix {})
    inputs.zen-browser.packages."${system}".default
    pkgs.audacity
    pkgs.chromium
    pkgs.telegram-desktop
    pkgs.kitty
    pkgs.obs-studio
    pkgs.rofi
    pkgs.wofi
    pkgs.mpv
    pkgs.kdenlive
    pkgs.discord-development
    pkgs.gparted
    pkgs.obsidian
    pkgs.zoom-us
    pkgs.pcmanfm-qt
    pkgs.polymc
    pkgs.nushell
    pkgs.appgate-sdp
    pkgs.slack
    pkgs.remmina
    pkgs.spotify

    # pkgs.Coding stuff
    pkgs.gnumake
    pkgs.gcc
    pkgs.nodejs
    pkgs.python
    pkgs.neovim
    pkgs.telescope
    pkgs.ripgrep
    pkgs.fd
    pkgs.carapace
    pkgs.cargo
    pkgs.vit
    (pkgs.python311.withPackages (ps: with ps; [ 
      pbr
      taskw
      notify-py
      pycairo
      pygobject3
      requests 
      bugwarrior
    ]))
    # pkgs.CLI utils
    pkgs.inotify-tools
    pkgs.tmuxinator
    pkgs.zoxide
    pkgs.neofetch
    pkgs.file
    pkgs.tree
    pkgs.wget
    pkgs.git
    pkgs.fzf
    pkgs.fastfetch
    pkgs.htop
    pkgs.nix-index
    pkgs.unzip
    pkgs.scrot
    pkgs.ffmpeg
    pkgs.light
    pkgs.lux
    pkgs.mediainfo
    pkgs.yazi
    pkgs.zram-generator
    pkgs.cava
    pkgs.zip
    pkgs.ntfs3g
    pkgs.yt-dlp
    pkgs.brightnessctl
    pkgs.swww
    pkgs.openssl
    pkgs.lazygit
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.tmux
    pkgs.pass
    pkgs.pinentry-curses
    pkgs.gnupg
    pkgs.poetry
    # pkgs.GUI utils
    pkgs.feh
    pkgs.imv
    pkgs.dmenu
    pkgs.screenkey
    pkgs.mako
    pkgs.gromit-mpx
    pkgs.taskwarrior3
    pkgs.timewarrior
    pkgs.gh
    pkgs.jq


    #Python


    # pkgs.Xorg stuff
    #pkgs.xterm
    #pkgs.xclip
    #pkgs.xorg.xbacklight

    # pkgs.Wayland stuff
    pkgs.xwayland
    pkgs.wl-clipboard
    pkgs.cliphist

    # pkgs.WMs and stuff
    pkgs.herbstluftwm
    pkgs.hyprland
    pkgs.seatd
    pkgs.xdg-desktop-portal-hyprland
    pkgs.polybar
    pkgs.waybar

    # pkgs.Sound
    pkgs.pipewire
    pkgs.pulseaudio
    pkgs.pamixer
    pkgs.pavucontrol
    # pkgs.GPU stuff 
    pkgs.amdvlk
    # pkgs.rocm-opencl-icd
    pkgs.glaxnimate

    # pkgs.Screenshotting
    pkgs.grim
    pkgs.grimblast
    pkgs.slurp
    pkgs.flameshot
    pkgs.swappy

    # pkgs.Other
    pkgs.home-manager
    pkgs.spice-vdagent
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.libsForQt5.qt5ct
    pkgs.papirus-nord
    pkgs.egl-wayland
    pkgs.networkmanagerapplet
    pkgs.openvpn
    pkgs.networkmanager-openvpn
    pkgs.docker
    pkgs.blender
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
