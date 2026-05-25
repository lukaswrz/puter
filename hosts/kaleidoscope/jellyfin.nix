{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.jellyfin-desktop
  ];
}
