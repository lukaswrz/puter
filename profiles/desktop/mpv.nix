{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.mympv.packages.${pkgs.system}.default
  ];
}
