{
  description = "musicomp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake.nixosModules.default = import ./module.nix self;

      perSystem = {
        pkgs,
        inputs',
        lib,
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            pkgs.python3
            pkgs.python3Packages.hatchling
          ];
        };

        packages.default = pkgs.callPackage ./package.nix {};
      };
    };
}
