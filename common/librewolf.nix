{ config, inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        stable = inputs.nixpkgs-stable.legacyPackages.${config.nixpkgs.hostPlatform};
      in
      {
        inherit (stable) librewolf;
      }
    )
  ];
}
