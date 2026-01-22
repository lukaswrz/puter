{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.kodi-wayland
  ];
}
