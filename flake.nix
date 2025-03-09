{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
    phps.url = "github:fossar/nix-phps";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux"];

      flake = {
        lib = nixpkgs.lib.extend (import ./lib.nix);

        nixosConfigurations = self.lib.genNixosConfigurations {inherit inputs;};
      };

      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        devenv.shells.default = {
          devenv.root = let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
            self.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "puter";

          imports = [
            ./devenv.nix
          ];

          packages = [
            inputs'.agenix.packages.agenix
          ];
        };

        packages = self.lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ./packages;
        };
      };
    };
}
