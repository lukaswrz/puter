{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.gnomeExtensions.no-overview
  ];
}
