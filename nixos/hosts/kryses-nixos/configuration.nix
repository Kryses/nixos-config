{ inputs, pkgs, channels, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../packages.nix
    ../../modules/bundle.nix
    ../../hardware/nvidia.nix
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
  nixpkgs.overlays = [ inputs.polymc.overlay ];

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
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0"; # used to be necessary, but doesn't seem to anymore
    };
  };
  services.speechd.enable = true;
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
    host = "0.0.0.0";
    port = 3000;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      TRANSFORMERS_CACHE = "${config.services.open-webui.stateDir}/cache";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      # Disable authentication
      WEBUI_AUTH = "False";
    };
    openFirewall = true;
  };
  environment.systemPackages = [
    pkgs.ollama-cuda
    pkgs.open-webui
    pkgs.oterm
  ];
}
