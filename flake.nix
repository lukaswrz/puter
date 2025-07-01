{
  description = "My NixOS configuration";

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

    agenix.url = "github:ryantm/agenix";
    hardware.url = "github:NixOS/nixos-hardware";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musicomp.url = "git+https://codeberg.org/helvetica/musicomp.git";
    hxwrap.url = "git+https://codeberg.org/helvetica/hxwrap.git";
    myphps.url = "git+https://codeberg.org/helvetica/myphps.git";
    forgesync.url = "git+https://codeberg.org/helvetica/forgesync.git";
    nini.url = "git+https://codeberg.org/helvetica/nini.git";
    xenumenu.url = "git+https://codeberg.org/helvetica/xenumenu.git";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
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
      ...
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
          inputs',
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";

            settings.global.excludes = [
              "LICENSE"
              "*.age"
              ".envrc"
            ];

            programs = {
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };

              shfmt = {
                enable = true;
                indent_size = 2;
              };

              mdformat.enable = true;
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = [
              inputs'.agenix.packages.default
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };
        };

      flake = {
        lib = nixpkgs.lib.extend (import ./lib.nix);

        nixosConfigurations = self.lib.genNixosConfigurations inputs;
      };
    };
}
