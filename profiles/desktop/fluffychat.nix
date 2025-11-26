{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.fluffychat
  ];
}
