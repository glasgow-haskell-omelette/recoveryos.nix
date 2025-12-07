{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
  };
  outputs =
    { nixpkgs, self, ... }:
    let
      x86 = nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib;
    in
    {
      packages = lib.genAttrs x86.stdenv.meta.platforms (_: rec {
        recoveryos = self.nixosConfigurations.recoveryos.config.system.build.isoImage;
        default = recoveryos;
      });

      nixosConfigurations.recoveryos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./recoveryos.nix
        ];
      };

    };
}
