{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:NixOS/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    myvim.url = "github:lukaswrz/myvim";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake = let
        commonNixosSystem = name: class:
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              attrName = name;
            };
            modules = [
              inputs.impermanence.nixosModules.impermanence
              inputs.agenix.nixosModules.default
              inputs.mailserver.nixosModule

              ./common
              ./class/${class}
              ./hosts/${name}

              ({lib, ...}: {networking.hostName = lib.mkDefault name;})
            ];
          };
      in {
        nixosConfigurations = builtins.mapAttrs commonNixosSystem {
          glacier = "desktop";
          flamingo = "desktop";
          scenery = "desktop";
          abacus = "server";
          vessel = "server";
        };
      };

      perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          packages = [inputs'.agenix.packages.agenix];
        };

        formatter = pkgs.alejandra;
      };
    };
}
