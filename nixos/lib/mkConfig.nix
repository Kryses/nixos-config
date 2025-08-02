user: { inputs, nixpkgs, nixpkgs-stable, home-manager, system, name, user, overlays, ... }:

nixpkgs.lib.nixosSystem rec {
  inherit system;
  specialArgs = {
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    inherit inputs system ;

  };
  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    ../hosts/${name}/configuration.nix
    # ../machines/${name}.nix
    # ../users/${user}/nixos.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-manager.nix;
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ];
}
