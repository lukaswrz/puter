{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.shpool
  ];
}
