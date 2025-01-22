{ inputs, pkgs, channels, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../packages.nix
    ../../modules/bundle.nix
    ../../hardware/nvidia.nix
    ../common/virualisation.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  disabledModules = [
    ../../modules/xserver.nix
  ];
  programs.nix-ld.enable = true;
  services.openssh.enable = true;
  nixpkgs.overlays = [
    inputs.polymc.overlay
    inputs.stable-diffusion-webui-nix.overlays.default
  ];

  networking.hostName = "kryses-nixos"; # Define your hostname.
  networking.extraHosts = ''
    192.168.1.231 ayon.work.local
  '';
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };
  time.timeZone = "America/New_York"; # Set your time zone.
  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties.
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes
  system.stateVersion = "23.05"; # Don't change it bro

  nix.extraOptions = ''
      trusted-users = root kryses
  '';
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0"; # used to be necessary, but doesn't seem to anymore
    };
  };
  services.speechd.enable = true;
  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    searxng
  ];
  services.searx = {
    enable = true;
    settings = {
      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
        formats = [
          "html"
          "json"
        ];
      };
      server = {
        port = 8888;
        bind_address = "0.0.0.0";
        secret_key = "secret key";
      };
    };
  };
  environment.systemPackages = [
    pkgs.ollama-cuda
    pkgs.open-webui
    pkgs.oterm
  ];
}
