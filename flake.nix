{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake = {
        nixosConfigurations = let
          lib = nixpkgs.lib.extend (import ./lib.nix);

          commonNixosSystem = name:
            lib.nixosSystem {
              specialArgs = {
                inherit inputs lib;
                attrName = name;
              };

              modules =
                (lib.findModules [
                  ./common
                  ./hosts/${name}
                ])
                ++ [
                  inputs.agenix.nixosModules.default
                  {networking.hostName = lib.mkDefault name;}
                ];
            };

          genHosts = lib.pipe (builtins.readDir ./hosts) [
            (lib.filterAttrs (_: type: type == "directory"))
            builtins.attrNames
            lib.genAttrs
          ];
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
