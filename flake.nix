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
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";

    flendor.url = "./vendor/flendor";
    musicomp.url = "./vendor/musicomp";
    hxwrap.url = "./vendor/hxwrap";
    myphps.url = "./vendor/myphps";
    forgesync.url = "./vendor/forgesync";
    nini.url = "./vendor/nini";
    xenumenu.url = "./vendor/xenumenu";
    mympv.url = "./vendor/mympv";
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
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };
        };

      flake.nixosConfigurations =
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

          genNixosConfigurations =
            inputs:
            let
              modulesDir = ./modules;
              profilesDir = ./profiles;
              commonDir = ./common;
              hostsDir = ./hosts;

              commonNixosSystem =
                name:
                lib.nixosSystem {
                  specialArgs = {
                    inherit inputs lib;
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
