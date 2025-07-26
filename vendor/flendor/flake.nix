{
  description = "flendor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      hooks,
      treefmt,
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        hooks.flakeModule
        treefmt.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";

            programs = {
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };

              shfmt.enable = true;
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          packages.default = pkgs.callPackage ./package.nix { };
        };
    };
}
