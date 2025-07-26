{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ouch
  ];
}
