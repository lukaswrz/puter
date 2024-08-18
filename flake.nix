{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake = {
        nixosConfigurations = let
          commonNixosSystem = name:
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
                attrName = name;
              };
              modules = [
                inputs.agenix.nixosModules.default

                ./common
                ./hosts/${name}

                ({lib, ...}: {networking.hostName = lib.mkDefault name;})
              ];
            };

          genHosts = (nixpkgs.lib.pipe (builtins.readDir ./hosts) [
            (nixpkgs.lib.filterAttrs (name: type: type == "directory" && name != "default.nix"))
            builtins.attrNames
            nixpkgs.lib.genAttrs
          ]);
        in
          genHosts commonNixosSystem;
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
