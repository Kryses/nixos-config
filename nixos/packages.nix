{ pkgs, nixpkgs, nixpkgs-python, inputs, ... }:
let
  system = "x86_64-linux";
in

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "python-2.7.18.8" "electron-25.9.0" "openssl-1.1.1w"];
  };
  environment.systemPackages = [
    # pkgs.legacyPackages.${system}.python39
    # nixpkgs-python.packages.${system}."3.9.2"
    inputs.zen-browser.packages.x86_64-linux.default
    # pkgs.tasksh
    pkgs.btop
    pkgs.zellij
    pkgs.satty
    pkgs.krita
    pkgs.ghostty
    pkgs.luajitPackages.luarocks
    pkgs.audacity
    pkgs.chromium
    pkgs.obs-studio
    pkgs.git
    pkgs.rofi
    pkgs.wofi
    pkgs.mpv
    pkgs.discord-development
    pkgs.gparted
    pkgs.obsidian
    # pkgs.pcmanfm-qt
    pkgs.nushell
    pkgs.appgate-sdp
    pkgs.slack
    pkgs.remmina
    pkgs.spotify
    pkgs.godotPackages_4_3.godot
    pkgs.deadnix
    pkgs.statix
    pkgs.termdown
    pkgs.sox
    pkgs.posting
    inputs.compose2nix.packages.x86_64-linux.default
    pkgs.qt6Packages.qtwayland


    # pkgs.Coding stuff
    pkgs.gnumake
    pkgs.gcc
    pkgs.nodejs
    pkgs.neovim
    pkgs.telescope
    pkgs.ripgrep
    pkgs.fd
    pkgs.carapace
    pkgs.cargo
    pkgs.vit
    (pkgs.python310.withPackages (ps: with ps; [ 
      # pbr
      # taskw
      # notify-py
      # pycairo
      # pygobject3
      # requests 
      # bugwarrior
      # pyside6
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
    pkgs.pinentry-all
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


    pkgs.xwayland
    pkgs.wl-clipboard
    pkgs.cliphist

    # pkgs.WMs and stuff
    pkgs.herbstluftwm
    pkgs.hyprland
    # pkgs.hyprlandPlugins.hyprsplit
    pkgs.seatd
    pkgs.xdg-desktop-portal-hyprland
    pkgs.waybar

    # pkgs.Sound
    pkgs.pipewire
    pkgs.pulseaudio
    pkgs.pamixer
    pkgs.pavucontrol
    # pkgs.GPU stuff 
    # pkgs.rocm-opencl-icd
    pkgs.glaxnimate
    pkgs.dwarf-fortress-packages.dwarf-fortress-full 
    pkgs.cataclysm-dda-git
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
    pkgs.oterm
    pkgs.bat
    pkgs.postman
    pkgs.devenv
    pkgs.protontricks
    pkgs.awscli2
    pkgs.aws-gate
    pkgs.ssm-session-manager-plugin
    pkgs.qmk
    pkgs.qmk-udev-rules
    pkgs.qmk_hid
    pkgs.via
    pkgs.vial
    pkgs.wofi-pass
    pkgs.wofi-emoji
    pkgs.imagemagick
    pkgs.libnotify
    pkgs.nixd
    pkgs.cmatrix
    pkgs.pyenv
    pkgs.tcl
    pkgs.bibletime
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts._0xproto
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
