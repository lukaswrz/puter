{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.raze
  ];
}
