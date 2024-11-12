{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    audacity
    chromium
    telegram-desktop
    kitty
    obs-studio
    rofi
    wofi
    mpv
    kdenlive
    discord-development
    gparted
    obsidian
    zoom-us
    pcmanfm-qt
    polymc
    nushell
    appgate-sdp
    slack
    remmina
    spotify

    # Coding stuff
    gnumake
    gcc
    nodejs
    python
    neovim
    telescope
    ripgrep
    fd
    carapace
    starship
    cargo
    (python3.withPackages (ps: with ps; [ requests ]))

    # CLI utils
    zoxide
    neofetch
    file
    tree
    wget
    git
    fzf
    fastfetch
    htop
    nix-index
    unzip
    scrot
    ffmpeg
    light
    lux
    mediainfo
    yazi
    zram-generator
    cava
    zip
    ntfs3g
    yt-dlp
    brightnessctl
    swww
    openssl
    lazygit
    bluez
    bluez-tools
    tmux
    pass
    gnupg
    poetry
    pyenv

    # GUI utils
    feh
    imv
    dmenu
    screenkey
    mako
    gromit-mpx

    # Xorg stuff
    #xterm
    #xclip
    #xorg.xbacklight

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist

    # WMs and stuff
    herbstluftwm
    hyprland
    seatd
    xdg-desktop-portal-hyprland
    polybar
    waybar

    # Sound
    pipewire
    pulseaudio
    pamixer
    pavucontrol
    # GPU stuff 
    amdvlk
    # rocm-opencl-icd
    glaxnimate

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
    home-manager
    spice-vdagent
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-nord
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
