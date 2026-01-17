{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:NixOS/nixos-hardware";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flendor = {
      url = "path:./vendor/flendor";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    musicomp = {
      url = "path:./vendor/musicomp";
      inputs = {
        flake-parts.follows = "flake-parts";
      };
    };
    forgesync = {
      url = "path:./vendor/forgesync";
      inputs = {
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    hxwrap = {
      url = "path:./vendor/hxwrap";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    mympv = {
      url = "path:./vendor/mympv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    zap = {
      url = "path:./vendor/zap";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
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
              "vendor/**"
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

          pre-commit.settings = {
            excludes = [
              "vendor"
            ];
            hooks = {
              treefmt.enable = true;
            };
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = [
              inputs'.agenix.packages.default
              inputs'.flendor.packages.default
              inputs'.zap.packages.default
              pkgs.nixos-facter
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          packages.zap = inputs'.zap.packages.default;
        };

      flake.nixosConfigurations =
        let
          genNixosConfigurations =
            inputs:
            let
              inherit (nixpkgs) lib;

              findModules =
                paths:
                builtins.concatMap (
                  path:
                  lib.pipe path [
                    (lib.fileset.fileFilter (file: file.hasExt "nix"))
                    lib.fileset.toList
                  ]
                ) paths;

              modulesDir = ./modules;
              profilesDir = ./profiles;
              commonDir = ./common;
              hostsDir = ./hosts;

              commonNixosSystem =
                name:
                lib.nixosSystem {
                  specialArgs = {
                    inherit inputs;
                    attrName = name;
                  };

                  modules = findModules [
                    modulesDir
                    profilesDir
                    commonDir
                    (hostsDir + /${name})
                  ];
                };

              hosts = lib.pipe hostsDir [
                builtins.readDir
                (lib.filterAttrs (_: type: type == "directory"))
                builtins.attrNames
              ];
            in
            lib.genAttrs hosts commonNixosSystem;
        in
        genNixosConfigurations inputs;
    };
}
