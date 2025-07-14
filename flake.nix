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
    mympv.url = "git+https://codeberg.org/helvetica/mympv.git";
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
