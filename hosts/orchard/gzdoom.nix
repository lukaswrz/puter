{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.gzdoom
  ];
}
