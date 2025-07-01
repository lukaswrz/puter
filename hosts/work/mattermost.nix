{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.mattermost-desktop
  ];
}
