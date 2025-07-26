{
  description = "PHP for me";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    phps.url = "github:fossar/nix-phps";
  };

  nixConfig = {
    extra-substituters = "https://fossar.cachix.org";
    extra-trusted-public-keys = "fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE=";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake.nixosModules = let
        myphps = import ./nixos self;
      in {
        inherit myphps;
        default = myphps;
      };

      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        packages = let
          myphp = pkgs.callPackage ./packages/myphp/package.nix {};
          myphps =
            builtins.mapAttrs (
              _: php:
                myphp.override {
                  inherit php;
                }
            )
            inputs'.phps.packages;
        in
          myphps
          // {
            symfony-cli = pkgs.callPackage ./packages/symfony-cli/package.nix {
              phps = myphps;
            };
          };
      };
    };
}
