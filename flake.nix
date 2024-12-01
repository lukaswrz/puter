{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    hxwrap.url = "github:lukaswrz/hxwrap";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake = let
        lib = nixpkgs.lib.extend (import ./lib.nix);
      in {
        inherit lib;

        nixosConfigurations = lib.genNixosConfigurations {
          inherit inputs;
          extraModules = [
            inputs.agenix.nixosModules.default
          ];
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

        packages.disk = pkgs.writeShellApplication {
          name = "disk";

          runtimeInputs = with pkgs; [
            util-linux
            jq
            e2fsprogs
            dosfstools
          ];

          text = builtins.readFile ./disk.sh;
        };
      };
    };
}
