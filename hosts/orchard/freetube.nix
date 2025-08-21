{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.freetube
  ];
}
