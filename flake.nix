{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;

    forEachSystem = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });

    mkSystem = class: name: args @ {modules ? [], ...}:
      nixpkgs.lib.nixosSystem ({
          specialArgs = {inherit inputs;};
        }
        // args
        // {
          modules =
            modules
            ++ [
              ({
                lib,
                config,
                ...
              }: {
                nix = {
                  registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

                  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

                  settings = {
                    experimental-features = "nix-command flakes";
                    auto-optimise-store = true;
                  };
                };

                nixpkgs.config.allowUnfree = true;

                networking.hostName = lib.mkDefault name;
              })
              (./common/nixos + "/${class}.nix")
              (./nixos + "/${name}")
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  extraSpecialArgs = {inherit inputs;};
                  users.lukas.imports = [
                    ({config, ...}: {
                      home.homeDirectory =
                        nixpkgs.lib.mkDefault "/home/${config.home.username}";

                      systemd.user.startServices = "sd-switch";
                    })
                    (./common/home-manager + "/${class}.nix")
                    (./home-manager + "/${name}/lukas.nix")
                  ];
                };
              }
              (sops-nix + "/modules/sops")
            ];
        });

    setups = {
      desktop = {
        glacier = {};

        flamingo = {};

        scenery = {};
      };

      server = {
        abacus = {};

        vessel = {};
      };
    };
  in {
    formatter = forEachSystem ({pkgs}: pkgs.alejandra);

    nixosConfigurations =
      nixpkgs.lib.attrsets.mergeAttrsList
      (builtins.attrValues (nixpkgs.lib.mapAttrs
        (class: configs: (nixpkgs.lib.mapAttrs (mkSystem class) configs))
        setups));
  };
}
