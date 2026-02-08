{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.beets
  ];
}
