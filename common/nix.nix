{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    optimise.automatic = true;

    settings = {
      trusted-users = [ "root" ] ++ config.users.normalUsers;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      flake-registry = "";
      use-xdg-base-directories = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
  };
}
