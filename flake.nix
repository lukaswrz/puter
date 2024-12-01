{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt.url = "github:numtide/treefmt-nix";
    hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    hxwrap.url = "github:lukaswrz/hxwrap";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    treefmt,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux"];

      flake = {
        lib = nixpkgs.lib.extend (import ./lib.nix);

        nixosConfigurations = self.lib.genNixosConfigurations {
          inherit inputs;
          extraModules = [
            inputs.agenix.nixosModules.default
          ];
        };
      };

      perSystem = {
        config,
        pkgs,
        inputs',
        ...
      }: {
        treefmt = ./treefmt.nix;

        pre-commit = {
          check.enable = true;

          settings = {
            hooks = {
              treefmt.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              shellcheck = {
                enable = true;
                excludes = [
                  "^\.envrc$"
                ];
              };
              flake-checker.enable = true;
            };
          };
        };

        devShells.default = pkgs.mkShellNoCC {
          inherit (config.pre-commit.devShell) shellHook;

          inputsFrom = [
            config.pre-commit.devShell
            config.treefmt.build.devShell
          ];

          packages = [
            inputs'.agenix.packages.agenix
          ];
        };

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
