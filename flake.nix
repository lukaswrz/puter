{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musicomp.url = "git+https://codeberg.org/helvetica/musicomp.git";
    hxwrap.url = "git+https://codeberg.org/helvetica/hxwrap.git";
    myphps.url = "git+https://codeberg.org/helvetica/myphps.git";
    forgesync.url = "git+https://codeberg.org/helvetica/forgesync.git";
  };

  nixConfig = {
    extra-substituters = "https://cosmic.cachix.org";
    extra-trusted-public-keys = "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake = {
        lib = nixpkgs.lib.extend (import ./lib.nix);

        nixosConfigurations = self.lib.genNixosConfigurations inputs;
      };

      perSystem =
        {
          pkgs,
          inputs',
          lib,
          ...
        }:
        {
          devShells.default = pkgs.mkShellNoCC {
            packages = [
              inputs'.agenix.packages.default
            ];
          };

          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage newScope;
            directory = ./packages;
          };
        };
    };
}
