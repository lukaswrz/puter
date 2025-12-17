{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.mympv.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
