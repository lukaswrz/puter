{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

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
    snoms.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

    musicomp.url = "git+https://hack.moontide.ink/m64/musicomp.git";
    forgesync.url = "git+https://hack.moontide.ink/m64/forgesync.git";
    hxwrap = {
      url = "git+https://hack.moontide.ink/m64/hxwrap.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zap = {
      url = "git+https://hack.moontide.ink/m64/zap.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f (
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            {
              inherit system pkgs;
              inherit (pkgs) treefmt;
              agenixPackages = inputs.agenix.packages.${system};
              zapPackages = inputs.zap.packages.${system};
            }
          )
        );
    in
    {
      devShells = forAllSystems (
        {
          pkgs,
          treefmt,
          agenixPackages,
          zapPackages,
          ...
        }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.nixos-facter
              agenixPackages.default
              zapPackages.default

              # Formatters
              treefmt
              pkgs.nixfmt
              pkgs.prettier
              pkgs.taplo
            ];
          };
        }
      );

      packages = forAllSystems (
        { zapPackages, ... }:
        {
          zap = zapPackages.default;
        }
      );

      nixosConfigurations =
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
                    secretsPath = ./secrets;
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

      formatter = forAllSystems ({ treefmt, ... }: treefmt);
    };
}
