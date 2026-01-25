{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
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
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flendor = {
      url = "git+https://hack.helveticanonstandard.net/helvetica/flendor.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    musicomp = {
      url = "git+https://hack.helveticanonstandard.net/helvetica/musicomp.git";
      inputs = {
        flake-parts.follows = "flake-parts";
      };
    };
    forgesync = {
      url = "git+https://hack.helveticanonstandard.net/helvetica/forgesync.git";
      inputs = {
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    hxwrap = {
      url = "git+https://hack.helveticanonstandard.net/helvetica/hxwrap.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    mympv = {
      url = "git+https://hack.helveticanonstandard.net/helvetica/mympv.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt.follows = "treefmt";
        hooks.follows = "hooks";
        flake-parts.follows = "flake-parts";
      };
    };
    zap = {
      url = "git+https://hack.helveticanonstandard.net/helvetica/zap.git";
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
                package = pkgs.nixfmt;
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
                    tailnet = "tailnet.helveticanonstandard.net";
                    pubkeys = import ./pubkeys.nix;
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
