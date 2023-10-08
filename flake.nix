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
    impermanence,
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

    mkSystem = name: {
      class,
      modules ? [],
      ...
    }:
      nixpkgs.lib.nixosSystem ({
          specialArgs = {inherit inputs;};
        }
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

                  nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

                  settings = {
                    experimental-features = "nix-command flakes";
                    auto-optimise-store = true;
                  };
                };

                nixpkgs.config.allowUnfree = true;

                networking.hostName = lib.mkDefault name;
              })
              (./system + "/${name}")
              ({lib, ...}: {
                home-manager = {
                  useGlobalPkgs = true;
                  extraSpecialArgs = {inherit inputs;};

                  users = lib.mapAttrs (username: user:
                    user
                    // {
                      imports =
                        user.imports
                        ++ [
                          ({config, ...}: {
                            home = {
                              username = lib.mkDefault username;
                              homeDirectory = lib.mkDefault "/home/${config.home.username}";
                            };

                            systemd.user.startServices = "sd-switch";
                          })
                          (./common/user + "/${class}.nix")
                        ];
                    })
                  (import (./user + "/${name}"));
                };
              })
              (./common/system + "/${class}.nix")

              home-manager.nixosModules.home-manager
              (impermanence + "/nixos.nix")
              (sops-nix + "/modules/sops")
            ];
        });

    systems = {
      glacier = {
        class = "desktop";
      };

      flamingo = {
        class = "desktop";
      };

      scenery = {
        class = "desktop";
      };

      abacus = {
        class = "server";
      };

      vessel = {
        class = "server";
      };
    };
  in {
    formatter = forEachSystem ({pkgs}: pkgs.alejandra);

    nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems;
  };
}
