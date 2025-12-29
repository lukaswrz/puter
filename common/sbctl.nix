{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sbctl
  ];
}
