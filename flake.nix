{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-compat.url = "github:edolstra/flake-compat";
    zen-browser.url = "https://flakehub.com/f/youwen5/zen-browser/0.1.204";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stable-diffusion-webui-nix = {
      url = "github:Janrupf/stable-diffusion-webui-nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    nixos-vfio.url = "github:j-brn/nixos-vfio";
    nixos-vfio.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    nix-spicetify.url = "github:the-argus/spicetify-nix";
    nix-spicetify.inputs.nixpkgs.follows = "nixpkgs";
    compose2nix.url = "github:aksiksi/compose2nix";
    compose2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    zen-browser,
    stylix,
    nixos-vfio,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";
    mkSystem = modules:
      nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = {
          inherit inputs outputs home-manager nixpkgs system zen-browser stylix nixos-vfio;
          pkgs-stable = import nixpkgs-stable {
            config.allowUnfree = true;
          };
        };
      };
  in {
    nixosConfigurations = {
      kryses-nixos = mkSystem [./hosts/kryses-nixos];
      kryses-mobile-nixos = mkSystem [./hosts/kryses-mobile-nixos];
      kryses-kirk = mkSystem [./hosts/kryses-kirk];
      kryses-tyr = mkSystem [./hosts/kryses-tyr];
      kryses-brokkr = mkSystem [./hosts/kryses-brokkr];
    };
    homeConfigurations = {
      kryses = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [./home/common];
      };
    };
  };
}
