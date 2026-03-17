
user: { nixpkgs, home-manager, system, user,  ... }:

nixpkgs.lib.nixosSystem {
  home-manager.lib.homeManagerConfiguration = {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [../users/kryses/home-manager.nix];
  };
}
