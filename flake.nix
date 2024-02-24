{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:K900/nixpkgs/plasma-6";
    hardware.url = "github:NixOS/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    forEachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system: f (import nixpkgs {inherit system;}));

    mkSystem = name: class:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          inputs.impermanence.nixosModules.impermanence
          inputs.agenix.nixosModules.default
          inputs.mailserver.nixosModule

          ./common
          (./class + "/${class}")
          (./hosts + "/${name}")

          ({lib, ...}: {networking.hostName = lib.mkDefault name;})
        ];
      };

    hosts = {
      glacier = "desktop";
      flamingo = "desktop";
      scenery = "desktop";
      abacus = "server";
      vessel = "server";
    };
  in {
    nixosConfigurations = builtins.mapAttrs mkSystem hosts;

    devShells = forEachSystem (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = [
          pkgs.nil
          inputs.agenix.packages.${pkgs.system}.agenix
          (pkgs.writeShellApplication {
            name = "home";
            runtimeInputs = [
              pkgs.git
              pkgs.flatpak
            ];
            text = builtins.readFile ./scripts/home.sh;
          })
        ];
      };
    });

    formatter = forEachSystem (pkgs: pkgs.alejandra);
  };
}
