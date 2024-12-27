{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Hardware support
    hardware.url = "github:NixOS/nixos-hardware";

    # Agenix
    agenix.url = "github:ryantm/agenix";

    # Helix
    hxwrap.url = "git+https://forgejo@tea.wrz.one/lukas/hxwrap.git";

    # COSMIC
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";

    # Devenv
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux"];

      flake = {
        lib = nixpkgs.lib.extend (import ./lib.nix);

        nixosConfigurations = self.lib.genNixosConfigurations {inherit inputs;};
      };

      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        devenv.shells.default = {
          devenv.root = let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "puter";

          imports = [
            ./devenv.nix
          ];

          packages = [
            inputs'.agenix.packages.agenix
          ];
        };

        packages.disk = pkgs.callPackage ./disk {};
      };
    };
}
