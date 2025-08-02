{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    zen-browser.url = "github:omarcresp/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polymc.url = "github:PolyMC/PolyMC";
    stable-diffusion-webui-nix = {
      url = "github:Janrupf/stable-diffusion-webui-nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit/53e417bce3b3aaf90ba2d86afd0c2a6d2cc3125e";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";
    mkSystem = modules:
      nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = {
          inherit inputs outputs;
          pkgs-stable = import nixpkgs-stable {
            config.allowUnfree = true;
          };
        };
      };
  in {
    nixosConfigurations = {
      kryses-nixos = mkSystem [./nixos/hosts/kryses-nixos];
      kryses-mobile-nixos = mkSystem [./nixos/hosts/kryses-mobile-nixos];
    };
    homeConfigurations = {
      kryses = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [./home-manager/home.nix];
      };
    };
  };
}
