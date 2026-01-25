{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        inherit (stable) librewolf;
      }
    )
  ];
}
