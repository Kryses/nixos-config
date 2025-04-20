{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    zen-browser.url = "github:omarcresp/zen-browser-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/2f893e185c850bcd6dbf4fbc0c61b1b90d23ff79";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

  outputs = { 
    self, 
    nixpkgs, 
    nixpkgs-stable, 
    home-manager, 
    nixos-hardware, 
    hyprland-plugins,
    hyprsplit,
    split-monitor-workspaces,
    ... }@inputs:

    let
      system = "x86_64-linux";
    in
    {
      # nixos - system hostname
      nixosConfigurations.kryses-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs system;
        };
        modules = [
          ./nixos/hosts/kryses-nixos/configuration.nix
          inputs.nixvim.nixosModules.nixvim
        ];
      };
      nixosConfigurations.kryses-mobile-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs system;
        };
        modules = [
          ./nixos/hosts/kryses-mobile-nixos/configuration.nix
          inputs.nixvim.nixosModules.nixvim
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ];
      };

      homeConfigurations.kryses = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home-manager/home.nix ];
        extraSpecialArgs = {inherit inputs;};


      };
    };
}
