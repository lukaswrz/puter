{
  config,
  inputs,
  lib,
  ...
}: {
  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      trusted-users = config.users.normalUsers;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
}
