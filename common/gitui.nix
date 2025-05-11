{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.gitui
  ];
}
